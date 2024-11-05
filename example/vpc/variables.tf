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

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
  default     = "arc"
}

variable "subnet_names" {
  type        = list(string)
  description = "List of subnet names to lookup"
  default     = ["arc-poc-private-subnet-private-us-east-1a", "arc-poc-private-subnet-private-us-east-1b"]
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC to add the resources"
  default     = "arc-poc-vpc"
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
  default     = "m5.large.search"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 2
}
