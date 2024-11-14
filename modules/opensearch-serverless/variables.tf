variable "name" {
  description = "The name of the OpenSearch collection."
  type        = string
}

variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
  default     = "dev"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
  default     = "arc"
}

variable "description" {
  description = "A description for the OpenSearch collection."
  type        = string
  default     = "OpenSearch collection domain for logs and search"
}

variable "use_standby_replicas" {
  description = "Flag to enable or disable standby replicas."
  type        = bool
  default     = true
}

variable "type" {
  description = "The type of OpenSearch collection."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the OpenSearch collection."
  type        = map(string)
  default     = {}
}

variable "create_encryption_policy" {
  description = "Flag to determine if encryption policy should be created."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the VPC endpoint."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "The VPC ID for the VPC endpoint."
  type        = string
  default     = null
}

variable "create_access_policy" {
  description = "Flag to determine if access policy should be created."
  type        = bool
  default     = true
}

variable "access_policy_rules" {
  description = "List of rules for the access policy."
  type = list(object({
    resource_type = string
    resource      = list(string)
    permissions   = list(string)
  }))
  default = []
}

variable "create_data_lifecycle_policy" {
  description = "Flag to determine if data lifecycle policy should be created."
  type        = bool
  default     = true
}

variable "data_lifecycle_policy_rules" {
  description = "Data lifecycle policy rules for the indices."
  type = list(object({
    indexes   = list(string)
    retention = string
  }))
  default = [
    {
      indexes   = ["*"]
      retention = "Unlimited"
    }
  ]
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
  description = "The name of the VPC endpoint security group."
  type        = string
  default     = "opensearch-vpc-sg"
}

variable "enable_public_access" {
  description = "Enable public access for the OpenSearch collection. If false, private access will be used."
  type        = bool
  default     = false
}
