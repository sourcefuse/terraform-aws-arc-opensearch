variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" # Change as needed
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


# variable "access_policy" {
#   description = "Access policy for the OpenSearch domain"
#   type        = string
# }
