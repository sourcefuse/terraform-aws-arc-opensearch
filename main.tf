################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4"
    }
  }
}

################################################################################
## iam
################################################################################
## admin
resource "aws_iam_role" "admin" {
  name = "${var.namespace}-${var.environment}-opensearch-admin"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Effect = "Allow"
          Principal = {
            Service = "opensearchservice.amazonaws.com"
          },
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "admin" {
  for_each = toset(local.admin_iam_role_policy_arn_attachments)

  role       = aws_iam_role.admin.name
  policy_arn = each.value
}

## read only
resource "aws_iam_role" "read_only" {
  name = "${var.namespace}-${var.environment}-opensearch-ro"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Effect = "Allow"
          Principal = {
            Service = "opensearchservice.amazonaws.com"
          },
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "read_only" {
  for_each = toset(local.ro_iam_role_policy_arn_attachments)

  role       = aws_iam_role.read_only.name
  policy_arn = each.value
}

################################################################################
## opensearch
################################################################################
resource "random_password" "admin_password" {
  count = var.generate_random_password == true ? 1 : 0

  length = 32
}

module "opensearch" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticsearch?ref=0.35.1"

  namespace   = var.namespace
  environment = var.environment

  ## network / security
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  security_groups         = var.security_group_ids
  zone_awareness_enabled  = var.zone_awareness_enabled
  availability_zone_count = length(var.availability_zones)

  ## opensearch configuration
  elasticsearch_version           = var.elasticsearch_version
  instance_type                   = var.instance_type
  instance_count                  = var.instance_count
  ebs_volume_size                 = var.ebs_volume_size
  encrypt_at_rest_enabled         = var.encrypt_at_rest_enabled
  node_to_node_encryption_enabled = var.node_to_node_encryption_enabled
  kibana_subdomain_name           = var.kibana_subdomain_name
  advanced_options                = var.advanced_options
  create_iam_service_linked_role  = var.create_iam_service_linked_role

  ## iam
  iam_role_arns = concat(
    [aws_iam_role.admin.arn],
    [aws_iam_role.read_only.arn],
  var.additional_iam_role_arns)
  iam_actions = var.iam_actions

  ## security
  advanced_security_options_enabled                        = var.advanced_security_options_enabled
  advanced_security_options_internal_user_database_enabled = var.advanced_security_options_internal_user_database_enabled
  advanced_security_options_master_user_name               = var.admin_username
  advanced_security_options_master_user_password           = local.advanced_security_options_master_user_password
  cognito_authentication_enabled                           = var.cognito_authentication_enabled

  tags = var.tags
}

################################################################################
## ssm
################################################################################
resource "aws_ssm_parameter" "this" {
  for_each = { for x in local.ssm_params : x.name => x }

  name      = each.value.name
  value     = each.value.value
  type      = each.value.type
  overwrite = true

  tags = merge(var.tags, tomap({
    Name = each.value.name
  }))
}
