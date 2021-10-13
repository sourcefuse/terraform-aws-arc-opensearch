locals {
  vpc_name = "travissaucier-${terraform.workspace}-vpc"

  tags = {
    Purpose     = "POC"
    Environment = terraform.workspace
  }
}