################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      version = ">= 5.64"
      source  = "hashicorp/aws"
    }
  }

}

provider "aws" {
  region = var.region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.6"

  environment = terraform.workspace
  project     = "terraform-aws-arc-opensearch"

  extra_tags = {
    Example = "True"
  }
}

################################################################################
## lookups
################################################################################
data "aws_caller_identity" "this" {}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = var.vpc_name != null ? [var.vpc_name] : ["${var.namespace}-${var.environment}-vpc"]
  }
}

# network
data "aws_subnets" "private" {
  filter {
    name = "tag:Name"

    ## try the created subnets from the upstream network module, or override with custom names
    values = length(var.subnet_names) > 0 ? var.subnet_names : [
      "${var.namespace}-${var.environment}-private-subnet-private-${var.region}a",
      "${var.namespace}-${var.environment}-private-subnet-private-${var.region}b"
    ]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

################################################################################
## opensearch
################################################################################
module "opensearch" {
  source = "../.."

  region             = var.region
  domain_name        = "${var.project_name}-${var.environment}-opensearch"
  engine_version     = var.engine_version
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  enable_vpc_options = true
  vpc_id             = data.aws_vpc.default.id
  subnet_ids         = local.private_subnet_ids
  ingress_rules      = var.ingress_rules
  egress_rules       = var.egress_rules
  access_policies    = var.access_policy

  tags = module.tags.tags
}
