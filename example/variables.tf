################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
  default     = "dev"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
  default     = "example"
}

variable "region" {
  type        = string
  description = "Name of the region resources will be deployed in"
  default     = "us-east-1"
}

################################################################################
## network
################################################################################
variable "vpc_name" {
  type        = string
  description = "Name of the VPC to add the resources"
  default     = null
}

variable "subnet_names" {
  type        = list(string)
  description = "List of subnet names to lookup"
  default     = []
}
