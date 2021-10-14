locals {
  base_name = "refarch-${terraform.workspace}"

  ## networking
  private_subnet_id = [for x in var.availability_zones: data.aws_subnet.private[x].id]
  public_subnet_id  = [for x in var.availability_zones: data.aws_subnet.public[x].id]

  private_subnets_cidr_block = [for x in var.availability_zones: data.aws_subnet.private[x].cidr_block]
  public_subnets_cidr_block  = [for x in var.availability_zones: data.aws_subnet.public[x].cidr_block]

  tags = {
    Purpose     = "POC"
    Environment = terraform.workspace
  }
}
