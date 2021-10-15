variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

## mine
variable "namespace" {
  default = "travissaucier"
}

variable "route_53_zone_name" {
  default = "poc2.sourcefuse.com"
}

variable "admin_username" {
  default     = "opensearch_admin"
  description = "Admin username when fine grained access control"
  type        = string
}
