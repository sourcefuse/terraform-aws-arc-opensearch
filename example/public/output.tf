output "opensearch_domain_endpoint" {
  description = "The endpoint of the OpenSearch domain."
  value       = module.opensearch.opensearch_domain_endpoint
}

output "opensearch_domain_arn" {
  description = "The ARN of the OpenSearch domain."
  value       = module.opensearch.opensearch_domain_arn
}

output "opensearch_domain_id" {
  description = "The unique identifier for the OpenSearch domain."
  value       = module.opensearch.opensearch_domain_id
}
