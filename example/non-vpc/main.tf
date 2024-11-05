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
## opensearch
################################################################################
module "opensearch" {
  source = "../.."

  region                         = var.region
  domain_name                    = "${var.project_name}-${var.environment}-opensearch"
  engine_version                 = var.engine_version
  instance_type                  = var.instance_type
  instance_count                 = var.instance_count
  enable_vpc_options             = false
  enable_encrypt_at_rest         = true
  auto_software_update_enabled   = false
  enable_domain_endpoint_options = true
  advanced_security_enabled      = true
  # access_policies                = var.access_policy
  enable_zone_awareness          = false
  tags                           = module.tags.tags
}



