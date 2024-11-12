###############################################################################
####################     opensearch domain   ##################################
###############################################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

module "opensearch" {
  source = "./modules/opensearch-domain"

  count = var.enable_serverless ? 0 : 1

  namespace   = var.namespace
  environment = var.environment

  name                     = var.name
  engine_version           = var.engine_version
  instance_type            = var.instance_type
  instance_count           = var.instance_count
  zone_awareness_enabled   = var.zone_awareness_enabled
  dedicated_master_enabled = var.dedicated_master_enabled
  dedicated_master_type    = var.dedicated_master_type
  dedicated_master_count   = var.dedicated_master_count
  use_ultrawarm            = var.use_ultrawarm
  warm_type                = var.warm_type
  retention_in_days        = var.retention_in_days
  warm_count               = var.warm_count
  ebs_enabled              = var.ebs_enabled
  volume_type              = var.volume_type
  volume_size              = var.volume_size
  iops                     = var.iops
  throughput               = var.throughput

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  encrypt_at_rest_enabled         = var.encrypt_at_rest_enabled
  kms_key_id                      = var.kms_key_id
  node_to_node_encryption_enabled = var.node_to_node_encryption_enabled
  enforce_https                   = var.enforce_https
  tls_security_policy             = var.tls_security_policy

  enable_custom_endpoint = var.enable_custom_endpoint
  custom_hostname        = var.custom_hostname
  custom_certificate_arn = var.custom_certificate_arn

  enable_snapshot_options = var.enable_snapshot_options
  snapshot_start_hour     = var.snapshot_start_hour
  log_types               = var.log_types

  access_policies                = var.access_policies
  advanced_security_enabled      = var.advanced_security_enabled
  anonymous_auth_enabled         = var.anonymous_auth_enabled
  internal_user_database_enabled = var.internal_user_database_enabled
  master_user_name               = var.master_user_name

  enable_auto_tune          = var.enable_auto_tune
  auto_tune_desired_state   = var.auto_tune_desired_state
  auto_tune_cron_expression = var.auto_tune_cron_expression
  auto_tune_duration_value  = var.auto_tune_duration_value
  auto_tune_duration_unit   = var.auto_tune_duration_unit
  auto_tune_start_at        = var.auto_tune_start_at

  enable_cognito_options   = var.enable_cognito_options
  cognito_identity_pool_id = var.cognito_identity_pool_id
  cognito_user_pool_id     = var.cognito_user_pool_id

  enable_off_peak_window_options = var.enable_off_peak_window_options
  off_peak_hours                 = var.off_peak_hours
  off_peak_minutes               = var.off_peak_minutes

  enable_zone_awareness   = var.enable_zone_awareness
  availability_zone_count = var.availability_zone_count

  enable_domain_endpoint_options = var.enable_domain_endpoint_options
  enable_encrypt_at_rest         = var.enable_encrypt_at_rest
  log_publishing_enabled         = var.log_publishing_enabled

  enable_vpc_options           = var.enable_vpc_options
  auto_software_update_enabled = var.auto_software_update_enabled

  saml_options = var.saml_options

  use_iam_arn_as_master_user = var.use_iam_arn_as_master_user
  master_user_arn            = var.master_user_arn

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules

  security_group_name = var.security_group_name

  tags = var.tags
}

##################################################
######## OpenSearch Serverless Domain  ###########
##################################################


module "opensearch_serverless" {
  source = "./modules/opensearch-serverless"

  count = var.enable_serverless ? 1 : 0

  namespace   = var.namespace
  environment = var.environment

  name                         = var.name
  description                  = var.description
  use_standby_replicas         = var.use_standby_replicas
  type                         = var.type
  create_encryption_policy     = var.create_encryption_policy
  subnet_ids                   = var.subnet_ids
  vpc_id                       = var.vpc_id
  create_access_policy         = var.create_access_policy
  access_policy_rules          = var.access_policy_rules
  create_data_lifecycle_policy = var.create_data_lifecycle_policy
  data_lifecycle_policy_rules  = var.data_lifecycle_policy_rules
  ingress_rules                = var.ingress_rules
  egress_rules                 = var.egress_rules
  security_group_name          = var.security_group_name
  enable_public_access         = var.enable_public_access

  tags = var.tags
}
