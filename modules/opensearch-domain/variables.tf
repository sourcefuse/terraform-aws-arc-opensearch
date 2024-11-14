variable "name" {
  description = "Name of the OpenSearch domain"
  type        = string
}

variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
}

variable "engine_version" {
  description = "OpenSearch or Elasticsearch engine version"
  type        = string
  default     = "OpenSearch_1.0"
}

variable "instance_type" {
  description = "Instance type for the OpenSearch domain"
  type        = string
  default     = "m5.large.search"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 2
}

variable "zone_awareness_enabled" {
  description = "Whether zone awareness is enabled"
  type        = bool
  default     = true
}

variable "dedicated_master_enabled" {
  description = "Whether dedicated master is enabled"
  type        = bool
  default     = false
}

variable "dedicated_master_type" {
  description = "Instance type for the dedicated master node"
  type        = string
  default     = "m5.large.search"
}

variable "dedicated_master_count" {
  description = "Number of dedicated master instances"
  type        = number
  default     = 3
}

variable "use_ultrawarm" {
  description = "Whether to enable UltraWarm nodes"
  type        = bool
  default     = false
}

variable "warm_type" {
  description = "UltraWarm node instance type"
  type        = string
  default     = "ultrawarm1.medium.search"
}

variable "retention_in_days" {
  description = "The number of days to retain log events in the log group"
  type        = number
  default     = 7
}

variable "warm_count" {
  description = "Number of UltraWarm instances"
  type        = number
  default     = 2
}

variable "ebs_enabled" {
  description = "Whether EBS is enabled for the domain"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "EBS volume size in GB"
  type        = number
  default     = 20
}

variable "iops" {
  description = "Provisioned IOPS for the volume"
  type        = number
  default     = null
}

variable "throughput" {
  description = "Provisioned throughput for the volume"
  type        = number
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC for OpenSearch domain"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the OpenSearch domain"
  type        = list(string)
  default     = []
}

variable "encrypt_at_rest_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption at rest"
  type        = string
  default     = ""
}

variable "node_to_node_encryption_enabled" {
  description = "Enable node-to-node encryption"
  type        = bool
  default     = true
}

variable "enforce_https" {
  description = "Force HTTPS on the OpenSearch endpoint"
  type        = bool
  default     = true
}

variable "tls_security_policy" {
  description = "TLS security policy for HTTPS endpoints"
  type        = string
  default     = "Policy-Min-TLS-1-2-PFS-2023-10"
}

variable "enable_custom_endpoint" {
  description = "Enable custom domain endpoint"
  type        = bool
  default     = false
}

variable "custom_hostname" {
  description = "Custom domain name for the OpenSearch endpoint"
  type        = string
  default     = ""
}

variable "custom_certificate_arn" {
  description = "ARN of the ACM certificate for the custom endpoint"
  type        = string
  default     = ""
}

variable "enable_snapshot_options" {
  description = "Enable snapshot options for the domain"
  type        = bool
  default     = false
}

variable "snapshot_start_hour" {
  description = "Start hour for the automated snapshot"
  type        = number
  default     = 0
}

variable "log_types" {
  description = "List of log types to publish to CloudWatch (Valid values: INDEX_SLOW_LOGS, SEARCH_SLOW_LOGS, ES_APPLICATION_LOGS, AUDIT_LOGS)"
  type        = list(string)
  default     = ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"]
}

variable "access_policies" {
  description = "Custom access policy for OpenSearch domain. If empty, default policy will be used"
  type        = string
  default     = ""
}

variable "advanced_security_enabled" {
  description = "Enable advanced security options (fine-grained access control)"
  type        = bool
  default     = false
}

variable "anonymous_auth_enabled" {
  description = "Enable anonymous authentication"
  type        = bool
  default     = false
}

variable "internal_user_database_enabled" {
  description = "Enable internal user database for fine-grained access control"
  type        = bool
  default     = true
}

variable "master_user_name" {
  description = "Master user name for OpenSearch"
  type        = string
  default     = "admin"
}

variable "enable_auto_tune" {
  description = "Enable Auto-Tune for the domain"
  type        = bool
  default     = false
}

variable "auto_tune_desired_state" {
  description = "Desired state of Auto-Tune"
  type        = string
  default     = "ENABLED"
}

variable "auto_tune_cron_expression" {
  description = "Cron expression for Auto-Tune maintenance schedule"
  type        = string
  default     = "0 1 * * ?"
}

variable "auto_tune_duration_value" {
  description = "Duration value for Auto-Tune maintenance"
  type        = number
  default     = 1
}

variable "auto_tune_duration_unit" {
  description = "Duration unit for Auto-Tune maintenance"
  type        = string
  default     = "HOURS"
}

variable "auto_tune_start_at" {
  description = "Start time for Auto-Tune maintenance"
  type        = string
  default     = "2024-10-23T01:00:00Z"
}

variable "enable_cognito_options" {
  description = "Enable Cognito authentication for the OpenSearch domain"
  type        = bool
  default     = false
}

variable "cognito_identity_pool_id" {
  description = "Cognito Identity Pool ID"
  type        = string
  default     = ""
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
  default     = ""
}

variable "enable_off_peak_window_options" {
  description = "Enable off-peak window options for the domain"
  type        = bool
  default     = false
}

variable "off_peak_hours" {
  description = "Off-peak window start time (hours)"
  type        = number
  default     = 0
}

variable "off_peak_minutes" {
  description = "Off-peak window start time (minutes)"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "enable_zone_awareness" {
  description = "Enable zone awareness for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "availability_zone_count" {
  description = "The number of availability zones to use for zone awareness."
  type        = number
  default     = 2
}

variable "enable_domain_endpoint_options" {
  description = "Enable custom domain endpoint options for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "enable_encrypt_at_rest" {
  description = "Enable encryption at rest for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "log_publishing_enabled" {
  description = "Whether to enable the log publishing option."
  type        = bool
  default     = true
}

variable "enable_vpc_options" {
  description = "Enable VPC options for the OpenSearch domain."
  type        = bool
  default     = false
}

variable "auto_software_update_enabled" {
  description = "Enable automatic software updates for OpenSearch"
  type        = bool
  default     = false
}

# SAML Options
variable "saml_options" {
  description = "Configuration block for SAML options in the OpenSearch domain."
  type = object({
    enabled                 = bool
    idp_entity_id           = optional(string)
    idp_metadata_content    = optional(string)
    roles_key               = optional(string)
    session_timeout_minutes = optional(number)
    subject_key             = optional(string)
  })
  default = {
    enabled                 = false
    idp_entity_id           = null
    idp_metadata_content    = null
    roles_key               = null
    session_timeout_minutes = null
    subject_key             = null
  }
}

variable "use_iam_arn_as_master_user" {
  description = "Set to true to use IAM ARN as the master user, false to create a master user."
  type        = bool
  default     = false
}

variable "master_user_arn" {
  description = "The ARN of the IAM role for fine-grained access control. Required if use_iam_arn_as_master_user is true."
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "A list of ingress rules for the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "A list of egress rules for the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = ""
}
