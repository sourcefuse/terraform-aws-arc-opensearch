# terraform-aws-opensearch

## Overview
:warning: This project was created to POC a complete OpenSearch build from the ground up. :warning:  

```shell
ssh -i ~/repos/sourcefuse/terraform-aws-opensearch/secrets/travissaucier-ssh-key -L 1444:vpc-refarch-dev-es-37n7q276d63yhckzloqoqjdayu.us-east-1.es.amazonaws.com:443 ec2-user@ec2-44-199-148-18.compute-1.amazonaws.com

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.62.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_key_pair"></a> [aws\_key\_pair](#module\_aws\_key\_pair) | git::https://github.com/cloudposse/terraform-aws-key-pair | 0.18.0 |
| <a name="module_ec2_bastion"></a> [ec2\_bastion](#module\_ec2\_bastion) | git::https://github.com/cloudposse/terraform-aws-ec2-bastion-server | n/a |
| <a name="module_elasticsearch"></a> [elasticsearch](#module\_elasticsearch) | git::https://github.com/cloudposse/terraform-aws-elasticsearch | 0.33.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy_document.es_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet_ids.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username when fine grained access control | `string` | `"opensearch_admin"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_inbound_cidr_blocks"></a> [inbound\_cidr\_blocks](#input\_inbound\_cidr\_blocks) | Inbound CIDR block for the bastion host. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace | `string` | `"refarch"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_public_dns"></a> [bastion\_host\_public\_dns](#output\_bastion\_host\_public\_dns) | n/a |
| <a name="output_bastion_host_public_ip"></a> [bastion\_host\_public\_ip](#output\_bastion\_host\_public\_ip) | n/a |
| <a name="output_bastion_host_ssh_user"></a> [bastion\_host\_ssh\_user](#output\_bastion\_host\_ssh\_user) | n/a |
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the Elasticsearch domain |
| <a name="output_domain_endpoint"></a> [domain\_endpoint](#output\_domain\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests |
| <a name="output_domain_hostname"></a> [domain\_hostname](#output\_domain\_hostname) | Elasticsearch domain hostname to submit index, search, and data upload requests |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the Elasticsearch domain |
| <a name="output_elasticsearch_user_iam_role_arn"></a> [elasticsearch\_user\_iam\_role\_arn](#output\_elasticsearch\_user\_iam\_role\_arn) | The ARN of the IAM role to allow access to Elasticsearch cluster |
| <a name="output_elasticsearch_user_iam_role_name"></a> [elasticsearch\_user\_iam\_role\_name](#output\_elasticsearch\_user\_iam\_role\_name) | The name of the IAM role to allow access to Elasticsearch cluster |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for Kibana without https scheme |
| <a name="output_kibana_hostname"></a> [kibana\_hostname](#output\_kibana\_hostname) | Kibana hostname |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | Private subnet CIDRs |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | Public subnet CIDRs |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security Group ID to control access to the Elasticsearch domain |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | VPC CIDR |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Workspaces 
This project utilizes workspaces. To see a list of workspaces, run `terraform workspace list`.    


## Versioning  
This project uses a `version.json` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged, 
the pipeline will kick off and tag the latest git commit.  

This project utilizes workspaces in the format of <region>-<environment>, i.e. `us-east-1-prod`.  

When creating new workspaces, please follow this naming convention and update the variables in 
`variables.tf` that use workspace mappings.

## Development

### Prerequisites

Install the prerequisites:  
* [golang](https://golang.org/doc/install#install)
* [pre-commit](https://pre-commit.com/#install)
* [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
* [terraform-docs](https://github.com/segmentio/terraform-docs)

Then run `pre-commit` on the repo:  

```shell
pre-commit install
pre-commit run --all-files
```

## Authors

This project is authored by:  
* SourceFuse  
