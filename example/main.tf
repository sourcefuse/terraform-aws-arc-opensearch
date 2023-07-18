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

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags?ref=1.1.0"

  environment = terraform.workspace
  project     = "terraform-aws-refarch-opensearch"

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

## network
data "aws_subnets" "private" {
  filter {
    name = "tag:Name"

    ## try the created subnets from the upstream network module, or override with custom names
    values = length(var.subnet_names) > 0 ? var.subnet_names : [
      "${var.namespace}-${var.environment}-private-subnet-private${var.region}a",
      "${var.namespace}-${var.environment}-private-subnet-private${var.region}b"
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
  source = "../"

  environment                    = var.environment
  namespace                      = var.namespace
  vpc_id                         = data.aws_vpc.default.id
  create_iam_service_linked_role = true # set to false if a cluster already exists
  subnet_ids                     = local.private_subnet_ids
  elasticsearch_version          = "7.7"
  instance_count                 = var.instance_count
  instance_type                  = var.instance_type
  availability_zones             = local.private_subnet_azs
  ebs_volume_size                = var.ebs_volume_size

  tags = module.tags.tags
}
