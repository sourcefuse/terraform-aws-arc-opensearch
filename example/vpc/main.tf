################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
## opensearch
################################################################################
module "opensearch" {
  source = "../.."

  namespace   = var.namespace
  environment = var.environment

  name               = "${var.project_name}-${var.environment}-opensearch"
  engine_version     = var.engine_version
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  enable_vpc_options = true
  vpc_id             = data.aws_vpc.default.id
  subnet_ids         = local.private_subnet_ids
  ingress_rules      = local.ingress_rules
  egress_rules       = local.egress_rules

  tags = module.tags.tags
}