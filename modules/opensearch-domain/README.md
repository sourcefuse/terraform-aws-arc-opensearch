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
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_iam_role.opensearch_cognito_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.opensearch_cognito_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.log_group_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.log_group_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_saml_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_saml_options) | resource |
| [aws_security_group.opensearch_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.master_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.master_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | Custom access policy for OpenSearch domain. If empty, default policy will be used | `string` | `""` | no |
| <a name="input_advanced_security_enabled"></a> [advanced\_security\_enabled](#input\_advanced\_security\_enabled) | Enable advanced security options (fine-grained access control) | `bool` | `false` | no |
| <a name="input_anonymous_auth_enabled"></a> [anonymous\_auth\_enabled](#input\_anonymous\_auth\_enabled) | Enable anonymous authentication | `bool` | `false` | no |
| <a name="input_auto_software_update_enabled"></a> [auto\_software\_update\_enabled](#input\_auto\_software\_update\_enabled) | Enable automatic software updates for OpenSearch | `bool` | `false` | no |
| <a name="input_auto_tune_cron_expression"></a> [auto\_tune\_cron\_expression](#input\_auto\_tune\_cron\_expression) | Cron expression for Auto-Tune maintenance schedule | `string` | `"0 1 * * ?"` | no |
| <a name="input_auto_tune_desired_state"></a> [auto\_tune\_desired\_state](#input\_auto\_tune\_desired\_state) | Desired state of Auto-Tune | `string` | `"ENABLED"` | no |
| <a name="input_auto_tune_duration_unit"></a> [auto\_tune\_duration\_unit](#input\_auto\_tune\_duration\_unit) | Duration unit for Auto-Tune maintenance | `string` | `"HOURS"` | no |
| <a name="input_auto_tune_duration_value"></a> [auto\_tune\_duration\_value](#input\_auto\_tune\_duration\_value) | Duration value for Auto-Tune maintenance | `number` | `1` | no |
| <a name="input_auto_tune_start_at"></a> [auto\_tune\_start\_at](#input\_auto\_tune\_start\_at) | Start time for Auto-Tune maintenance | `string` | `"2024-10-23T01:00:00Z"` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | The number of availability zones to use for zone awareness. | `number` | `2` | no |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | Cognito Identity Pool ID | `string` | `""` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | Cognito User Pool ID | `string` | `""` | no |
| <a name="input_custom_certificate_arn"></a> [custom\_certificate\_arn](#input\_custom\_certificate\_arn) | ARN of the ACM certificate for the custom endpoint | `string` | `""` | no |
| <a name="input_custom_hostname"></a> [custom\_hostname](#input\_custom\_hostname) | Custom domain name for the OpenSearch endpoint | `string` | `""` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated master instances | `number` | `3` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Whether dedicated master is enabled | `bool` | `false` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type for the dedicated master node | `string` | `"m5.large.search"` | no |
| <a name="input_ebs_enabled"></a> [ebs\_enabled](#input\_ebs\_enabled) | Whether EBS is enabled for the domain | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | A list of egress rules for the security group. | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_enable_auto_tune"></a> [enable\_auto\_tune](#input\_enable\_auto\_tune) | Enable Auto-Tune for the domain | `bool` | `false` | no |
| <a name="input_enable_cognito_options"></a> [enable\_cognito\_options](#input\_enable\_cognito\_options) | Enable Cognito authentication for the OpenSearch domain | `bool` | `false` | no |
| <a name="input_enable_custom_endpoint"></a> [enable\_custom\_endpoint](#input\_enable\_custom\_endpoint) | Enable custom domain endpoint | `bool` | `false` | no |
| <a name="input_enable_domain_endpoint_options"></a> [enable\_domain\_endpoint\_options](#input\_enable\_domain\_endpoint\_options) | Enable custom domain endpoint options for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_enable_encrypt_at_rest"></a> [enable\_encrypt\_at\_rest](#input\_enable\_encrypt\_at\_rest) | Enable encryption at rest for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_enable_off_peak_window_options"></a> [enable\_off\_peak\_window\_options](#input\_enable\_off\_peak\_window\_options) | Enable off-peak window options for the domain | `bool` | `false` | no |
| <a name="input_enable_snapshot_options"></a> [enable\_snapshot\_options](#input\_enable\_snapshot\_options) | Enable snapshot options for the domain | `bool` | `false` | no |
| <a name="input_enable_vpc_options"></a> [enable\_vpc\_options](#input\_enable\_vpc\_options) | Enable VPC options for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_enable_zone_awareness"></a> [enable\_zone\_awareness](#input\_enable\_zone\_awareness) | Enable zone awareness for the OpenSearch domain. | `bool` | `false` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enforce_https"></a> [enforce\_https](#input\_enforce\_https) | Force HTTPS on the OpenSearch endpoint | `bool` | `true` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | OpenSearch or Elasticsearch engine version | `string` | `"OpenSearch_1.0"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | n/a | yes |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A list of ingress rules for the security group. | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the OpenSearch domain | `string` | `"m5.large.search"` | no |
| <a name="input_internal_user_database_enabled"></a> [internal\_user\_database\_enabled](#input\_internal\_user\_database\_enabled) | Enable internal user database for fine-grained access control | `bool` | `true` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | Provisioned IOPS for the volume | `number` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption at rest | `string` | `""` | no |
| <a name="input_log_publishing_enabled"></a> [log\_publishing\_enabled](#input\_log\_publishing\_enabled) | Whether to enable the log publishing option. | `bool` | `true` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | List of log types to publish to CloudWatch (Valid values: INDEX\_SLOW\_LOGS, SEARCH\_SLOW\_LOGS, ES\_APPLICATION\_LOGS, AUDIT\_LOGS) | `list(string)` | <pre>[<br>  "INDEX_SLOW_LOGS",<br>  "SEARCH_SLOW_LOGS"<br>]</pre> | no |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | The ARN of the IAM role for fine-grained access control. Required if use\_iam\_arn\_as\_master\_user is true. | `string` | `""` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | Master user name for OpenSearch | `string` | `"admin"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the OpenSearch domain | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | n/a | yes |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Enable node-to-node encryption | `bool` | `true` | no |
| <a name="input_off_peak_hours"></a> [off\_peak\_hours](#input\_off\_peak\_hours) | Off-peak window start time (hours) | `number` | `0` | no |
| <a name="input_off_peak_minutes"></a> [off\_peak\_minutes](#input\_off\_peak\_minutes) | Off-peak window start time (minutes) | `number` | `0` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain log events in the log group | `number` | `7` | no |
| <a name="input_saml_options"></a> [saml\_options](#input\_saml\_options) | Configuration block for SAML options in the OpenSearch domain. | <pre>object({<br>    enabled                 = bool<br>    idp_entity_id           = optional(string)<br>    idp_metadata_content    = optional(string)<br>    roles_key               = optional(string)<br>    session_timeout_minutes = optional(number)<br>    subject_key             = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "idp_entity_id": null,<br>  "idp_metadata_content": null,<br>  "roles_key": null,<br>  "session_timeout_minutes": null,<br>  "subject_key": null<br>}</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name for the security group | `string` | `""` | no |
| <a name="input_snapshot_start_hour"></a> [snapshot\_start\_hour](#input\_snapshot\_start\_hour) | Start hour for the automated snapshot | `number` | `0` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the OpenSearch domain | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | Provisioned throughput for the volume | `number` | `null` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | TLS security policy for HTTPS endpoints | `string` | `"Policy-Min-TLS-1-2-PFS-2023-10"` | no |
| <a name="input_use_iam_arn_as_master_user"></a> [use\_iam\_arn\_as\_master\_user](#input\_use\_iam\_arn\_as\_master\_user) | Set to true to use IAM ARN as the master user, false to create a master user. | `bool` | `false` | no |
| <a name="input_use_ultrawarm"></a> [use\_ultrawarm](#input\_use\_ultrawarm) | Whether to enable UltraWarm nodes | `bool` | `false` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | EBS volume size in GB | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | EBS volume type | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC for OpenSearch domain | `string` | `null` | no |
| <a name="input_warm_count"></a> [warm\_count](#input\_warm\_count) | Number of UltraWarm instances | `number` | `2` | no |
| <a name="input_warm_type"></a> [warm\_type](#input\_warm\_type) | UltraWarm node instance type | `string` | `"ultrawarm1.medium.search"` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Whether zone awareness is enabled | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | The ARN of the CloudWatch Log Group associated with OpenSearch. |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ID of the KMS Key used for CloudWatch Logs encryption. |
| <a name="output_opensearch_domain_arn"></a> [opensearch\_domain\_arn](#output\_opensearch\_domain\_arn) | The ARN of the OpenSearch domain. |
| <a name="output_opensearch_domain_endpoint"></a> [opensearch\_domain\_endpoint](#output\_opensearch\_domain\_endpoint) | The endpoint URL for the OpenSearch domain. |
| <a name="output_opensearch_domain_id"></a> [opensearch\_domain\_id](#output\_opensearch\_domain\_id) | The ID of the OpenSearch domain |
<!-- END_TF_DOCS -->
