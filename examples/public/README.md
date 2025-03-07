# terraform-aws-arc-opensearch-example

## Overview
Terraform module example for supporting AWS OpenSearch.  

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_opensearch"></a> [opensearch](#module\_opensearch) | ../.. | n/a |
| <a name="module_opensearch_serverless"></a> [opensearch\_serverless](#module\_opensearch\_serverless) | ../.. | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | OpenSearch or Elasticsearch engine version | `string` | `"OpenSearch_2.15"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `"dev"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the OpenSearch domain | `string` | `"m5.large.search"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the OpenSearch domain | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. refarch | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_opensearch_domain_arn"></a> [opensearch\_domain\_arn](#output\_opensearch\_domain\_arn) | The ARN of the OpenSearch domain. |
| <a name="output_opensearch_domain_endpoint"></a> [opensearch\_domain\_endpoint](#output\_opensearch\_domain\_endpoint) | The endpoint of the OpenSearch domain. |
| <a name="output_opensearch_domain_id"></a> [opensearch\_domain\_id](#output\_opensearch\_domain\_id) | The unique identifier for the OpenSearch domain. |
| <a name="output_opensearch_serverless_arn"></a> [opensearch\_serverless\_arn](#output\_opensearch\_serverless\_arn) | The ARN of the OpenSearch Serverless collection. |
| <a name="output_opensearch_serverless_collection_endpoint"></a> [opensearch\_serverless\_collection\_endpoint](#output\_opensearch\_serverless\_collection\_endpoint) | The ID of the OpenSearch Serverless collection |
| <a name="output_opensearch_serverless_collection_id"></a> [opensearch\_serverless\_collection\_id](#output\_opensearch\_serverless\_collection\_id) | The ID of the OpenSearch Serverless collection |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
