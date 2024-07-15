################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

data "aws_caller_identity" "this" {}

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
## opensearch
################################################################################
module "opensearch" {
  source = "../.."

  name                           = "${var.environment}-${var.namespace}-os"
  environment                    = var.environment
  namespace                      = var.namespace
  create_iam_service_linked_role = true # set to false if a cluster already exists
  elasticsearch_version          = "7.7"
  instance_count                 = var.instance_count
  instance_type                  = var.instance_type
  ebs_volume_size                = var.ebs_volume_size
  vpc_enabled                    = false
  allowed_cidr_blocks            = ["106.219.122.75/32"]                             // non VPC ES to allow anonymous access from whitelisted IP ranges without requests signing
  anonymous_iam_actions          = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"] // Actions for anonymous user
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"] // Actions for user
  tags                           = module.tags.tags
}
