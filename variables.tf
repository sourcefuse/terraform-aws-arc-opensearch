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

variable "namespace" {
  default     = "refarch"
  type        = string
  description = "Namespace"
}

variable "admin_username" {
  default     = "opensearch_admin"
  description = "Admin username when fine grained access control"
  type        = string
}

variable "inbound_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "Inbound CIDR block for the bastion host."
  type        = list(string)
}
