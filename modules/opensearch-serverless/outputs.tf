output "opensearch_collection_id" {
  description = "The ID of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.id
}

output "opensearch_collection_arn" {
  description = "The ARN of the OpenSearch collection"
  value       = aws_opensearchserverless_collection.this.arn
}
