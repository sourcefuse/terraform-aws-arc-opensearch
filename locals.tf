locals {
  base_name = "refarch-${terraform.workspace}"

  ## networking
  private_subnet_id = [for x in var.availability_zones : data.aws_subnet.private[x].id]
  public_subnet_id  = [for x in var.availability_zones : data.aws_subnet.public[x].id]

  private_subnets_cidr_block = [for x in var.availability_zones : data.aws_subnet.private[x].cidr_block]
  public_subnets_cidr_block  = [for x in var.availability_zones : data.aws_subnet.public[x].cidr_block]

  ssm_params = [
    {
      name  = "/${var.namespace}/${local.base_name}/opensearch/admin_password"
      value = random_password.admin_password.result
      type  = "SecureString"
    },
    {
      name  = "/${var.namespace}/${local.base_name}/opensearch/admin_username"
      value = var.admin_username
      type  = "SecureString"
    }
  ]

  inbound_public_cidrs = var.inbound_cidr_blocks

  tags = merge(var.tags, tomap({
    Purpose     = "POC"
    Environment = terraform.workspace
  }))
}
