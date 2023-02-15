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
## networking / security
################################################################################
/*
resource "aws_security_group" "this" {
  name_prefix   = "${var.namespace}-${var.environment}-opensearch"
  vpc_id = var.vpc_id

  ingress {
    description = ""
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = local.public_subnets_cidr_block
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = local.public_subnets_cidr_block
    security_groups = [aws_security_group.public.id]
  }

  egress {
    description = ""
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = local.public_subnets_cidr_block
    security_groups = [aws_security_group.public.id]
  }

#  egress {
#    description = "Egress to everywhere"
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-private-sg"
  }))
}

resource "aws_security_group" "public" {
  name   = "${local.base_name}-public-sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.inbound_public_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.inbound_public_cidrs
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.private_subnets_cidr_block
    #    security_groups = [aws_security_group.private.id]
  }

  tags = merge(var.tags, tomap({
    NamePrefix = "${var.namespace}-${var.environment}-opensearch"
  }))
}
*/

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
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  security_groups        = var.security_group_ids
  zone_awareness_enabled = var.zone_awareness_enabled

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
  iam_role_arns = var.iam_role_arns
  iam_actions   = var.iam_actions

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
