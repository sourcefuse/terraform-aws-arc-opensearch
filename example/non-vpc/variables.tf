variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # Change as needed
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


variable "access_policy" {
  description = "Access policy for the OpenSearch domain"
  type        = string
}
