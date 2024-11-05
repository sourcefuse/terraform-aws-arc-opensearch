![Module Structure](./static/banner.png)

# [terraform-aws-arc-opensearch](https://github.com/sourcefuse/terraform-aws-arc-opensearch)

<a href="https://github.com/sourcefuse/terraform-aws-arc-opensearch/releases/latest"><img src="https://img.shields.io/github/release/sourcefuse/terraform-aws-arc-opensearch.svg?style=for-the-badge" alt="Latest Release"/></a> <a href="https://github.com/sourcefuse/terraform-aws-arc-opensearch/commits"><img src="https://img.shields.io/github/last-commit/sourcefuse/terraform-aws-arc-opensearch.svg?style=for-the-badge" alt="Last Updated"/></a> ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=sourcefuse_terraform-aws-arc-opensearch)](https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-opensearch)

[![Known Vulnerabilities](https://github.com/sourcefuse/terraform-aws-arc-opensearch/actions/workflows/snyk.yaml/badge.svg)](https://github.com/sourcefuse/terraform-aws-arc-opensearch/actions/workflows/snyk.yaml)
## Overview
Terraform module for supporting AWS OpenSearch. Creates an admin role and outputs parameters to SSM for downstream utilization or additional automation.

## Usage

See the `example/vpc` folder for a working module example.

```hcl
################################################################################
## opensearch
################################################################################
module "opensearch" {
  source                         = "sourcefuse/arc-opensearch/aws"
  version                        = "0.1.2"
  environment                    = var.environment
  namespace                      = var.namespace
  vpc_id                         = data.aws_vpc.default.id
  create_iam_service_linked_role = false # set to false if a cluster already exists
  subnet_ids                     = local.private_subnet_ids
  availability_zones             = local.private_subnet_azs

  tags = module.tags.tags
}

```
See the `example/non-vpc` folder if you want your os to be public

```hcl
################################################################################
## opensearch
################################################################################
module "opensearch" {
  source                         = "sourcefuse/arc-opensearch/aws"
  version                        = "1.0.3"
  region                         = var.region
  domain_name                    = "${var.project_name}-${var.environment}-opensearch"
  engine_version                 = var.engine_version
  instance_type                  = var.instance_type
  instance_count                 = var.instance_count
  enable_vpc_options             = false
  enable_encrypt_at_rest         = true
  auto_software_update_enabled   = false
  enable_domain_endpoint_options = true
  advanced_security_enabled      = true
  access_policies                = var.access_policy
  enable_zone_awareness          = false

  tags = module.tags.tags
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 6.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_opensearch"></a> [opensearch](#module\_opensearch) | cloudposse/elasticsearch/aws | 0.47.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_iam_role_arns"></a> [additional\_iam\_role\_arns](#input\_additional\_iam\_role\_arns) | List of additional IAM role ARNs to permit access to the Elasticsearch domain | `list(string)` | `[]` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username when fine grained access control | `string` | `"os_admin"` | no |
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Key-value string pairs to specify advanced configuration options | `map(any)` | <pre>{<br>  "override_main_response_version": false,<br>  "rest.action.multi.allow_explicit_index": "true"<br>}</pre> | no |
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | AWS Elasticsearch Kibana enchanced security plugin enabling (forces new resource) | `bool` | `true` | no |
| <a name="input_advanced_security_options_internal_user_database_enabled"></a> [advanced\_security\_options\_internal\_user\_database\_enabled](#input\_advanced\_security\_options\_internal\_user\_database\_enabled) | Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin | `bool` | `true` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| <a name="input_anonymous_iam_actions"></a> [anonymous\_iam\_actions](#input\_anonymous\_iam\_actions) | List of actions to allow for the anonymous (`*`) IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost` | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to deploy the cluster in. | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_cognito_authentication_enabled"></a> [cognito\_authentication\_enabled](#input\_cognito\_authentication\_enabled) | Whether to enable Amazon Cognito authentication with Kibana | `bool` | `false` | no |
| <a name="input_cognito_iam_role_arn"></a> [cognito\_iam\_role\_arn](#input\_cognito\_iam\_role\_arn) | ARN of the IAM role that has the AmazonESCognitoAccess policy attached | `string` | `""` | no |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | The ID of the Cognito Identity Pool to use | `string` | `""` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | The ID of the Cognito User Pool to use | `string` | `""` | no |
| <a name="input_create_iam_service_linked_role"></a> [create\_iam\_service\_linked\_role](#input\_create\_iam\_service\_linked\_role) | Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info | `bool` | `true` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Fully qualified domain for custom endpoint. | `string` | `""` | no |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | ACM certificate ARN for custom endpoint. | `string` | `""` | no |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | Whether to enable custom endpoint for the Elasticsearch domain. | `bool` | `false` | no |
| <a name="input_custom_opensearch_password"></a> [custom\_opensearch\_password](#input\_custom\_opensearch\_password) | Custom Administrator password to be assigned to `var.admin_username`. If undefined, it will be a randomly generated password. Does not work if `var.generate_random_password` is `true`. | `string` | `""` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | EBS volumes for data storage in GB | `number` | `10` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | Version of ElasticSearch or OpenSearch to deploy (\_e.g.\_ OpenSearch\_2.3, OpenSearch\_1.3, OpenSearch\_1.2, OpenSearch\_1.1, OpenSearch\_1.0, 7.4, 7.1, etc. | `string` | `"OpenSearch_2.3"` | no |
| <a name="input_enable_public_access"></a> [enable\_public\_access](#input\_enable\_public\_access) | Set to false if ES should be deployed outside of VPC. | `bool` | `false` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | n/a | yes |
| <a name="input_generate_random_password"></a> [generate\_random\_password](#input\_generate\_random\_password) | Generate a random password for the OpenSearch Administrator.<br>If this value is `true` and `var.custom_opensearch_password` is defined, `var.custom_opensearch_password` will be ignored. | `bool` | `true` | no |
| <a name="input_iam_actions"></a> [iam\_actions](#input\_iam\_actions) | List of actions to allow for the IAM roles, e.g. es:ESHttpGet, es:ESHttpPut, es:ESHttpPost | `list(string)` | `[]` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of data nodes in the cluster. | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | ElasticSearch or OpenSearch instance type for data nodes in the cluster | `string` | `"t3.medium.elasticsearch"` | no |
| <a name="input_kibana_subdomain_name"></a> [kibana\_subdomain\_name](#input\_kibana\_subdomain\_name) | The name of the subdomain for Kibana in the DNS zone (\_e.g.\_ kibana, ui, ui-es, search-ui, kibana.elasticsearch) | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the OpenSearch resource | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | n/a | yes |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security groups to assign OpenSearch | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnet IDs to assign OpenSearch | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to every resource | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where resources will be deployed to | `string` | `null` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Enable zone awareness for Elasticsearch cluster | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the OpenSearch domain |
| <a name="output_domain_endpoint"></a> [domain\_endpoint](#output\_domain\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests |
| <a name="output_domain_hostname"></a> [domain\_hostname](#output\_domain\_hostname) | OpenSearch domain hostname to submit index, search, and data upload requests |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the OpenSearch domain |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for Kibana without https scheme |
| <a name="output_kibana_hostname"></a> [kibana\_hostname](#output\_kibana\_hostname) | Kibana hostname |
| <a name="output_opensearch_user_iam_role_arn"></a> [opensearch\_user\_iam\_role\_arn](#output\_opensearch\_user\_iam\_role\_arn) | The ARN of the IAM role to allow access to OpenSearch cluster |
| <a name="output_opensearch_user_iam_role_name"></a> [opensearch\_user\_iam\_role\_name](#output\_opensearch\_user\_iam\_role\_name) | The name of the IAM role to allow access to OpenSearch cluster |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security Group ID to control access to the OpenSearch domain |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->  

## Versioning  
This project uses a `.version` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged,
the pipeline will kick off and tag the latest git commit.  

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-refarch-opensearch
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:  
* SourceFuse ARC Team

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_saml_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_saml_options) | resource |
| [aws_security_group.opensearch_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.master_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.master_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | Access policy for the OpenSearch domain | `string` | n/a | yes |
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
| <a name="input_cognito_role_arn"></a> [cognito\_role\_arn](#input\_cognito\_role\_arn) | Cognito Role ARN | `string` | `""` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | Cognito User Pool ID | `string` | `""` | no |
| <a name="input_cold_storage_enabled"></a> [cold\_storage\_enabled](#input\_cold\_storage\_enabled) | Flag to enable or disable cold storage options | `bool` | `false` | no |
| <a name="input_cold_storage_retention_period"></a> [cold\_storage\_retention\_period](#input\_cold\_storage\_retention\_period) | Retention period for cold storage in days | `number` | `30` | no |
| <a name="input_custom_certificate_arn"></a> [custom\_certificate\_arn](#input\_custom\_certificate\_arn) | ARN of the ACM certificate for the custom endpoint | `string` | `""` | no |
| <a name="input_custom_hostname"></a> [custom\_hostname](#input\_custom\_hostname) | Custom domain name for the OpenSearch endpoint | `string` | `""` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated master instances | `number` | `3` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Whether dedicated master is enabled | `bool` | `false` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type for the dedicated master node | `string` | `"m4.large.search"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the OpenSearch domain | `string` | n/a | yes |
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
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `"dev"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A list of ingress rules for the security group. | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the OpenSearch domain | `string` | `"m4.large.search"` | no |
| <a name="input_internal_user_database_enabled"></a> [internal\_user\_database\_enabled](#input\_internal\_user\_database\_enabled) | Enable internal user database for fine-grained access control | `bool` | `true` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | Provisioned IOPS for the volume | `number` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption at rest | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the CloudWatch Log Group | `string` | `"arc-example-log-group"` | no |
| <a name="input_log_publishing_enabled"></a> [log\_publishing\_enabled](#input\_log\_publishing\_enabled) | Whether to enable the log publishing option. | `bool` | `true` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | List of log types to publish to CloudWatch (Valid values: INDEX\_SLOW\_LOGS, SEARCH\_SLOW\_LOGS, ES\_APPLICATION\_LOGS, AUDIT\_LOGS) | `list(string)` | <pre>[<br>  "INDEX_SLOW_LOGS",<br>  "SEARCH_SLOW_LOGS"<br>]</pre> | no |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | The ARN of the IAM role for fine-grained access control. Required if use\_iam\_arn\_as\_master\_user is true. | `string` | `""` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | Master user name for OpenSearch | `string` | `"admin"` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Enable node-to-node encryption | `bool` | `true` | no |
| <a name="input_off_peak_hours"></a> [off\_peak\_hours](#input\_off\_peak\_hours) | Off-peak window start time (hours) | `number` | `0` | no |
| <a name="input_off_peak_minutes"></a> [off\_peak\_minutes](#input\_off\_peak\_minutes) | Off-peak window start time (minutes) | `number` | `0` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | `"sourcefuse"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_rest_action_multi_allow_explicit_index"></a> [rest\_action\_multi\_allow\_explicit\_index](#input\_rest\_action\_multi\_allow\_explicit\_index) | Setting to control whether to allow explicit index usage in multi-document actions | `string` | `"false"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain log events in the log group | `number` | `7` | no |
| <a name="input_saml_options"></a> [saml\_options](#input\_saml\_options) | Configuration block for SAML options in the OpenSearch domain. | <pre>object({<br>    enabled                 = bool<br>    idp_entity_id           = optional(string)<br>    idp_metadata_content    = optional(string)<br>    roles_key               = optional(string)<br>    session_timeout_minutes = optional(number)<br>    subject_key             = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "idp_entity_id": null,<br>  "idp_metadata_content": null,<br>  "roles_key": null,<br>  "session_timeout_minutes": null,<br>  "subject_key": null<br>}</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name for the security group | `string` | `""` | no |
| <a name="input_snapshot_start_hour"></a> [snapshot\_start\_hour](#input\_snapshot\_start\_hour) | Start hour for the automated snapshot | `number` | `0` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the OpenSearch domain | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | Provisioned throughput for the volume | `number` | `null` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | TLS security policy for HTTPS endpoints | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_use_iam_arn_as_master_user"></a> [use\_iam\_arn\_as\_master\_user](#input\_use\_iam\_arn\_as\_master\_user) | Set to true to use IAM ARN as the master user, false to create a master user. | `bool` | `false` | no |
| <a name="input_use_ultrawarm"></a> [use\_ultrawarm](#input\_use\_ultrawarm) | Whether to enable UltraWarm nodes | `bool` | `false` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | EBS volume size in GB | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | EBS volume type | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC for OpenSearch domain | `string` | `null` | no |
| <a name="input_warm_count"></a> [warm\_count](#input\_warm\_count) | Number of UltraWarm instances | `number` | `2` | no |
| <a name="input_warm_type"></a> [warm\_type](#input\_warm\_type) | UltraWarm node instance type | `string` | `"ultrawarm1.medium.search"` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Whether zone awareness is enabled | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->