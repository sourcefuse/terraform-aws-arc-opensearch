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

################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  description = "Name of the region resources will be deployed in"
}
