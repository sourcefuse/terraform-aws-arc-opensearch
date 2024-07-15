################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
  default     = "poc"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
  default     = "arc"
}

variable "region" {
  type        = string
  description = "Name of the region resources will be deployed in"
  default     = "us-east-1"
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
