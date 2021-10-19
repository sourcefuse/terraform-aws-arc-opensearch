output "bastion_host_public_dns" {
  value = try(module.ec2_bastion[0].public_dns, null)
}

output "bastion_host_ssh_user" {
  value = try(module.ec2_bastion[0].ssh_user, null)
}

output "bastion_host_public_ip" {
  value = try(module.ec2_bastion[0].public_ip, null)
}

output "public_subnet_cidrs" {
  value       = [for x in data.aws_subnet.public : x.cidr_block]
  description = "Public subnet CIDRs"
}

output "private_subnet_cidrs" {
  value       = [for x in data.aws_subnet.private : x.cidr_block]
  description = "Private subnet CIDRs"
}

output "vpc_cidr" {
  value       = data.aws_vpc.this.cidr_block
  description = "VPC CIDR"
}

output "security_group_id" {
  value       = module.elasticsearch.security_group_id
  description = "Security Group ID to control access to the Elasticsearch domain"
}

output "domain_arn" {
  value       = module.elasticsearch.domain_arn
  description = "ARN of the Elasticsearch domain"
}

output "domain_id" {
  value       = module.elasticsearch.domain_id
  description = "Unique identifier for the Elasticsearch domain"
}

output "domain_endpoint" {
  value       = module.elasticsearch.domain_endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
}

output "kibana_endpoint" {
  value       = module.elasticsearch.kibana_endpoint
  description = "Domain-specific endpoint for Kibana without https scheme"
}

output "domain_hostname" {
  value       = module.elasticsearch.domain_hostname
  description = "Elasticsearch domain hostname to submit index, search, and data upload requests"
}

output "kibana_hostname" {
  value       = module.elasticsearch.kibana_hostname
  description = "Kibana hostname"
}

output "elasticsearch_user_iam_role_name" {
  value       = module.elasticsearch.elasticsearch_user_iam_role_name
  description = "The name of the IAM role to allow access to Elasticsearch cluster"
}

output "elasticsearch_user_iam_role_arn" {
  value       = module.elasticsearch.elasticsearch_user_iam_role_arn
  description = "The ARN of the IAM role to allow access to Elasticsearch cluster"
}