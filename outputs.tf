################################################################################
## security
################################################################################
output "security_group_id" {
  value       = module.opensearch.security_group_id
  description = "Security Group ID to control access to the OpenSearch domain"
}

output "opensearch_user_iam_role_name" {
  value       = module.opensearch.elasticsearch_user_iam_role_name
  description = "The name of the IAM role to allow access to OpenSearch cluster"
}

output "opensearch_user_iam_role_arn" {
  value       = module.opensearch.elasticsearch_user_iam_role_arn
  description = "The ARN of the IAM role to allow access to OpenSearch cluster"
}

################################################################################
## opensearch
################################################################################
output "domain_arn" {
  value       = module.opensearch.domain_arn
  description = "ARN of the OpenSearch domain"
}

output "domain_id" {
  value       = module.opensearch.domain_id
  description = "Unique identifier for the OpenSearch domain"
}

output "domain_endpoint" {
  value       = module.opensearch.domain_endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
}

output "kibana_endpoint" {
  value       = module.opensearch.kibana_endpoint
  description = "Domain-specific endpoint for Kibana without https scheme"
}

output "domain_hostname" {
  value       = module.opensearch.domain_hostname
  description = "OpenSearch domain hostname to submit index, search, and data upload requests"
}

output "kibana_hostname" {
  value       = module.opensearch.kibana_hostname
  description = "Kibana hostname"
}
