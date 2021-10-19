###########################################
## imports / lookups
###########################################
# TODO: clean up lookups
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.base_name}-vpc"]
  }
}

## network
data "aws_subnet" "private" {
  for_each = toset(var.availability_zones)

  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["refarch-${terraform.workspace}-privatesubnet-private-${each.key}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.availability_zones)

  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["refarch-${terraform.workspace}-publicsubnet-public-${each.key}"]
  }
}

## network
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name = "tag:Name"

    values = [
      "refarch-${terraform.workspace}-privatesubnet-private-${var.region}a",
      "refarch-${terraform.workspace}-privatesubnet-private-${var.region}b"
    ]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name = "tag:Name"

    values = [
      "refarch-${terraform.workspace}-publicsubnet-public-${var.region}a",
      "refarch-${terraform.workspace}-publicsubnet-public-${var.region}b"
    ]
  }
}