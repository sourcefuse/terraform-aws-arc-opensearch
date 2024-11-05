################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      version = ">= 5.0"
      source  = "hashicorp/aws"
    }
    random = {
      version = ">= 3.0"
      source  = "hashicorp/random"
    }
  }

}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

######## OpenSearch Security Group Options #######
resource "aws_security_group" "opensearch_sg" {
  count       = var.enable_vpc_options ? 1 : 0
  name        = var.security_group_name
  description = "Security group for the OpenSearch Domain"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}

######### Create a KMS key for CloudWatch log group ########
resource "aws_kms_key" "log_group_key" {
  description             = "KMS key for CloudWatch log group encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "EnableRootPermissions",
        Effect    = "Allow",
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid       = "AllowCloudWatchLogs",
        Effect    = "Allow",
        Principal = { Service = "logs.${data.aws_region.current.name}.amazonaws.com" },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "log_group_key_alias" {
  name          = "alias/cloudwatch-os-log-group-key"
  target_key_id = aws_kms_key.log_group_key.id
}

######## CloudWatch Log Group Options #######
resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.namespace}-${var.environment}-opensearch-log-group"
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.log_group_key.arn

  depends_on = [aws_kms_key.log_group_key]
}

######## CloudWatch Log Resource Policy Options #######
resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = "${var.namespace}-${var.environment}-opensearch-log-group-policy"

  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "opensearchservice.amazonaws.com"
        },
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.this.name}:*"
      }
    ]
  })
}

######### Generate a random password #########
resource "random_password" "master_user_password" {
  count            = var.advanced_security_enabled && !var.use_iam_arn_as_master_user ? 1 : 0
  length           = 32
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "!@#$%^&*()-_=+[]{}"
}

######### Store the generated password in ssm #########
resource "aws_ssm_parameter" "master_user_password" {
  count = var.advanced_security_enabled && !var.use_iam_arn_as_master_user ? 1 : 0
  name  = "/opensearch/${var.namespace}/${var.environment}/master_user_password"
  type  = "SecureString"
  value = random_password.master_user_password[0].result
}

######### IAM role for OpenSearch Service Cognito Access ########
resource "aws_iam_role" "opensearch_cognito_role" {
  count = var.enable_cognito_options ? 1 : 0
  name  = "${var.namespace}-${var.environment}-opensearch-cognito-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "es.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

####### Attach the Aws managed policy to the role #######
resource "aws_iam_role_policy_attachment" "opensearch_cognito_policy_attachment" {
  count      = var.enable_cognito_options ? 1 : 0
  role       = aws_iam_role.opensearch_cognito_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonOpenSearchServiceCognitoAccess"
}

##############################################
######## OpenSearch Domain Options ###########
##############################################
resource "aws_opensearch_domain" "this" {
  domain_name    = var.name
  engine_version = var.engine_version

  ######## Cluster configuration #######
  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = var.zone_awareness_enabled
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : 0
    warm_enabled             = var.use_ultrawarm ? true : false
    warm_type                = var.use_ultrawarm ? var.warm_type : null
    warm_count               = var.use_ultrawarm ? var.warm_count : null

    dynamic "zone_awareness_config" {
      for_each = var.enable_zone_awareness ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  ######## EBS options #######
  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops        = var.iops
    throughput  = var.throughput
  }

  ######## VPC Options #######
  dynamic "vpc_options" {
    for_each = var.enable_vpc_options ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = [aws_security_group.opensearch_sg[0].id]
    }
  }

  ######## Snapshot options #######
  dynamic "snapshot_options" {
    for_each = var.enable_snapshot_options ? [1] : []
    content {
      automated_snapshot_start_hour = var.snapshot_start_hour
    }
  }

  ######## Encryption options #######
  dynamic "encrypt_at_rest" {
    for_each = var.enable_encrypt_at_rest ? [1] : []
    content {
      enabled    = var.encrypt_at_rest_enabled
      kms_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }

  ######## Node-to-node encryption options #######
  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  ######## Domain endpoint #######
  dynamic "domain_endpoint_options" {
    for_each = var.enable_domain_endpoint_options ? [1] : []
    content {
      enforce_https                   = var.enforce_https
      tls_security_policy             = var.tls_security_policy
      custom_endpoint                 = var.enable_custom_endpoint ? var.custom_hostname : null
      custom_endpoint_certificate_arn = var.enable_custom_endpoint ? var.custom_certificate_arn : null
    }
  }

  ###### access_policies #######
  access_policies = var.access_policies != "" ? var.access_policies : local.access_policy

  ######## Log publishing options #######
  dynamic "log_publishing_options" {
    for_each = var.log_types
    content {
      log_type                 = log_publishing_options.value
      enabled                  = var.log_publishing_enabled
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    }
  }

  ######## Advanced Security Options #######
  dynamic "advanced_security_options" {
    for_each = var.advanced_security_enabled ? [1] : []
    content {
      enabled                        = true
      anonymous_auth_enabled         = var.anonymous_auth_enabled
      internal_user_database_enabled = var.internal_user_database_enabled

      ######### master user options or IAM ARN ########
      dynamic "master_user_options" {
        for_each = var.use_iam_arn_as_master_user ? [] : [1]
        content {
          master_user_name     = var.master_user_name
          master_user_password = aws_ssm_parameter.master_user_password[0].value
          master_user_arn      = var.use_iam_arn_as_master_user ? var.master_user_arn : null
        }
      }

    }
  }
  ######## Auto-Tune options #######
  dynamic "auto_tune_options" {
    for_each = var.enable_auto_tune ? [1] : []
    content {
      desired_state = var.auto_tune_desired_state

      dynamic "maintenance_schedule" {
        for_each = var.enable_auto_tune ? [1] : []
        content {
          cron_expression_for_recurrence = var.auto_tune_cron_expression
          duration {
            value = var.auto_tune_duration_value
            unit  = var.auto_tune_duration_unit
          }
          start_at = var.auto_tune_start_at
        }
      }
    }
  }

  ######## Cognito options #######
  dynamic "cognito_options" {
    for_each = var.enable_cognito_options ? [1] : []
    content {
      enabled          = true
      identity_pool_id = var.cognito_identity_pool_id
      role_arn         = aws_iam_role.opensearch_cognito_role[0].arn
      user_pool_id     = var.cognito_user_pool_id
    }
  }

  ######## Off-peak window options #######
  dynamic "off_peak_window_options" {
    for_each = var.enable_off_peak_window_options ? [1] : []
    content {
      enabled = true
      off_peak_window {
        window_start_time {
          hours   = var.off_peak_hours
          minutes = var.off_peak_minutes
        }
      }
    }
  }

  ######## Software update options #######
  software_update_options {
    auto_software_update_enabled = var.auto_software_update_enabled
  }

  ######## Tags #######
  tags = var.tags
}

######## SAML Options #######
resource "aws_opensearch_domain_saml_options" "this" {
  count       = var.saml_options.enabled ? 1 : 0
  domain_name = aws_opensearch_domain.this.domain_name

  saml_options {
    idp {
      entity_id        = var.saml_options.idp_entity_id
      metadata_content = var.saml_options.idp_metadata_content
    }
    roles_key               = var.saml_options.roles_key
    session_timeout_minutes = var.saml_options.session_timeout_minutes
    subject_key             = var.saml_options.subject_key
  }
}
