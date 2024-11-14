output "opensearch_domain_endpoint" {
  description = "The endpoint URL for the OpenSearch domain."
  value       = aws_opensearch_domain.this.endpoint
}

output "opensearch_domain_arn" {
  description = "The ARN of the OpenSearch domain."
  value       = aws_opensearch_domain.this.arn
}

output "opensearch_domain_id" {
  description = "The ID of the OpenSearch domain"
  value       = aws_opensearch_domain.this.domain_id
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group associated with OpenSearch."
  value       = aws_cloudwatch_log_group.this.arn
}

output "kms_key_id" {
  description = "The ID of the KMS Key used for CloudWatch Logs encryption."
  value       = aws_kms_key.log_group_key.id
}
