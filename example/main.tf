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
data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

################################################################################
## opensearch
################################################################################
module "opensearch" {
  source = "../"

  environment = var.environment
  namespace   = var.namespace
  vpc_id      = data.aws_vpc.default.id

  tags = module.tags.tags
}
