locals {
  private_subnet_ids = [for s in data.aws_subnet.private : s.id]
  private_subnet_azs = [for s in data.aws_subnet.private : s.availability_zone]
}
