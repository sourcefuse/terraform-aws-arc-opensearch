<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.75.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.opensearch_custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.opensearch_access_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.opensearch_access_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_opensearchserverless_access_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_access_policy) | resource |
| [aws_opensearchserverless_collection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection) | resource |
| [aws_opensearchserverless_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_lifecycle_policy) | resource |
| [aws_opensearchserverless_security_policy.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.private_network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.public_network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_rules"></a> [access\_policy\_rules](#input\_access\_policy\_rules) | List of rules for the access policy. | <pre>list(object({<br>    resource_type = string<br>    resource      = list(string)<br>    permissions   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_collection_name"></a> [collection\_name](#input\_collection\_name) | The name of the OpenSearch collection. | `string` | n/a | yes |
| <a name="input_create_access_policy"></a> [create\_access\_policy](#input\_create\_access\_policy) | Flag to determine if access policy should be created. | `bool` | `true` | no |
| <a name="input_create_data_lifecycle_policy"></a> [create\_data\_lifecycle\_policy](#input\_create\_data\_lifecycle\_policy) | Flag to determine if data lifecycle policy should be created. | `bool` | `true` | no |
| <a name="input_create_encryption_policy"></a> [create\_encryption\_policy](#input\_create\_encryption\_policy) | Flag to determine if encryption policy should be created. | `bool` | `true` | no |
| <a name="input_create_network_policy"></a> [create\_network\_policy](#input\_create\_network\_policy) | Flag to determine if network policy should be created. | `bool` | `true` | no |
| <a name="input_create_private_access"></a> [create\_private\_access](#input\_create\_private\_access) | Enable or disable private access for the OpenSearch collection | `bool` | `false` | no |
| <a name="input_create_public_access"></a> [create\_public\_access](#input\_create\_public\_access) | Enable or disable public access for the OpenSearch collection | `bool` | `false` | no |
| <a name="input_data_lifecycle_policy_rules"></a> [data\_lifecycle\_policy\_rules](#input\_data\_lifecycle\_policy\_rules) | Data lifecycle policy rules for the indices. | <pre>list(object({<br>    indexes   = list(string)<br>    retention = string<br>  }))</pre> | <pre>[<br>  {<br>    "indexes": [<br>      "*"<br>    ],<br>    "retention": "Unlimited"<br>  }<br>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the OpenSearch collection. | `string` | `"OpenSearch collection domain for logs and search"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | A list of egress rules for the security group. | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"dev"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A list of ingress rules for the security group. | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | `"arc"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the OpenSearch collection. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of OpenSearch collection. | `string` | n/a | yes |
| <a name="input_use_standby_replicas"></a> [use\_standby\_replicas](#input\_use\_standby\_replicas) | Flag to enable or disable standby replicas. | `bool` | `true` | no |
| <a name="input_vpc_create_security_group"></a> [vpc\_create\_security\_group](#input\_vpc\_create\_security\_group) | Flag to determine if a security group for VPC endpoint should be created. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for the VPC endpoint. | `string` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC endpoint. | `string` | `null` | no |
| <a name="input_vpc_security_group_name"></a> [vpc\_security\_group\_name](#input\_vpc\_security\_group\_name) | The name of the VPC endpoint security group. | `string` | `"opensearch-vpc-sg"` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | A list of subnet IDs for the VPC endpoint. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_opensearch_collection_arn"></a> [opensearch\_collection\_arn](#output\_opensearch\_collection\_arn) | The ARN of the OpenSearch collection |
| <a name="output_opensearch_collection_id"></a> [opensearch\_collection\_id](#output\_opensearch\_collection\_id) | The ID of the OpenSearch Serverless collection |
<!-- END_TF_DOCS -->
