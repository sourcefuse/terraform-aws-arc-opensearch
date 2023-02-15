################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to apply to every resource"
}

################################################################################
## network / security
################################################################################
variable "vpc_id" {
  type        = string
  description = "ID of the VPC where resources will be deployed to"
}

variable "subnet_ids" {
  description = "List of Subnet IDs to assign OpenSearch"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security groups to assign OpenSearch"
  type        = list(string)
  default     = []
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "Enable zone awareness for Elasticsearch cluster"
  default     = true
}

variable "iam_role_arns" {
  type        = list(string)
  description = "List of IAM role ARNs to permit access to the Elasticsearch domain"
  default     = []
}

variable "iam_actions" {
  type        = list(string)
  description = "List of actions to allow for the IAM roles, e.g. es:ESHttpGet, es:ESHttpPut, es:ESHttpPost"
  default     = ["es:*"]
}

################################################################################
## opensearch
################################################################################
variable "admin_username" {
  type        = string
  description = "Admin username when fine grained access control"
  default     = "os_admin"
}

variable "generate_random_password" {
  type        = bool
  description = "Generate a random password for the OpenSearch Administrator."
  default     = true
}

variable "elasticsearch_version" {
  type        = string
  description = "Version of ElasticSearch or OpenSearch to deploy (_e.g._ 7.4, 7.1, OpenSearch_1.0, etc."
  default     = "OpenSearch_2.5.0"
}

variable "instance_type" {
  type        = string
  description = "ElasticSearch or OpenSearch instance type for data nodes in the cluster"
  default     = "t3.medium.elasticsearch"
}

variable "instance_count" {
  type        = number
  description = "Number of data nodes in the cluster."
  default     = 2
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS volumes for data storage in GB"
  default     = 10
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  description = "Whether to enable encryption at rest"
  default     = true
}

variable "node_to_node_encryption_enabled" {
  type        = bool
  description = "Whether to enable node-to-node encryption"
  default     = true
}

variable "kibana_subdomain_name" {
  type        = string
  description = "The name of the subdomain for Kibana in the DNS zone (_e.g._ kibana, ui, ui-es, search-ui, kibana.elasticsearch)"
  default     = ""
}

## security
variable "custom_opensearch_password" {
  type        = string
  description = "Custom Administrator password to be assigned to `var.admin_username`. If undefined, it will be a randomly generated password. Does not work if `var.generate_random_password` is `true`."
  sensitive   = true
  default     = ""
}

variable "advanced_options" {
  type        = map(any)
  description = "Key-value string pairs to specify advanced configuration options"
  default = {
    "rest.action.multi.allow_explicit_index" = "true"
    override_main_response_version           = false
  }
}

variable "advanced_security_options_enabled" {
  type        = bool
  description = "AWS Elasticsearch Kibana enchanced security plugin enabling (forces new resource)"
  default     = true
}

variable "advanced_security_options_internal_user_database_enabled" {
  type        = bool
  description = "Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin"
  default     = true
}

variable "cognito_authentication_enabled" {
  type        = bool
  description = "Whether to enable Amazon Cognito authentication with Kibana"
  default     = false
}
