variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default = [
    "us-east-2a",
    "us-east-2c"
  ]
}

## mine
variable "namespace" {
  default = "travissaucier"
}

variable "route_53_zone_name" {
  default = "poc2.sourcefuse.com"
}