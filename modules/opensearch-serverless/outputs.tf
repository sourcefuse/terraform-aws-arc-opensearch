output "opensearch_collection_id" {
  description = "The ID of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.id
}

output "opensearch_collection_arn" {
  description = "The ARN of the OpenSearch collection"
  value       = aws_opensearchserverless_collection.this.arn
}

output "opensearch_collection_endpoint" {
  description = "The Endpoint of the OpenSearch collection"
  value       = aws_opensearchserverless_collection.this.collection_endpoint
}
