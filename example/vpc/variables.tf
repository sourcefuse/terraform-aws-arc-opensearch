variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # Change as needed
}

variable "project_name" {
  type        = string
  default     = "sourcefuse"
  description = "Project name"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "domain_name" {
  description = "Name of the OpenSearch domain"
  type        = string
}

variable "engine_version" {
  description = "OpenSearch or Elasticsearch engine version"
  type        = string
  default     = "OpenSearch_1.0" 
}

variable "instance_type" {
  description = "Instance type for the OpenSearch domain"
  type        = string
  default     = "m4.large.search" 
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 2 
}

variable "vpc_id" {
  description = "VPC ID for the OpenSearch domain"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the domain"
  type        = list(string)
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

variable "subnet_ids" {
  description = "List of subnet IDs for the OpenSearch domain"
  type        = list(string)
}

variable "access_policy" {
  description = "Access policy for the OpenSearch domain"
  type        = string
}

variable "ingress_rules" {
  description = "A list of ingress rules for the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "A list of egress rules for the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}