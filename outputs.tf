output "opensearch_domain_endpoint" {
  description = "The endpoint of the OpenSearch domain."
  value       = length(module.opensearch) > 0 ? module.opensearch[0].opensearch_domain_endpoint : null
}

output "opensearch_domain_arn" {
  description = "The ARN of the OpenSearch domain."
  value       = length(module.opensearch) > 0 ? module.opensearch[0].opensearch_domain_arn : null
}

output "opensearch_domain_id" {
  description = "The unique identifier for the OpenSearch domain."
  value       = length(module.opensearch) > 0 ? trimprefix(module.opensearch[0].opensearch_domain_id, "${data.aws_caller_identity.current.account_id}/") : null
}


###############################################
## Outputs for OpenSearch Serverless Module
###############################################

output "opensearch_serverless_collection_arn" {
  value       = length(module.opensearch_serverless) > 0 ? module.opensearch_serverless[0].opensearch_collection_arn : null
  description = "The ARN of the OpenSearch Serverless collection"
}

output "opensearch_serverless_collection_id" {
  value       = length(module.opensearch_serverless) > 0 ? module.opensearch_serverless[0].opensearch_collection_id : null
  description = "The ID of the OpenSearch Serverless collection"
}
