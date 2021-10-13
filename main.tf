###########################################
## defaults / versions / providers
###########################################
terraform {
  required_version = ">= 1.0.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::757583164619:role/sourcefuse-poc-2-user-role"
  }
}

###########################################
## vpc
###########################################
module "vpc" {
  source    = "git::https://github.com/cloudposse/terraform-aws-vpc?ref=0.27.0"
  name      = "vpc"
  namespace = var.namespace
  stage     = terraform.workspace

  cidr_block = "10.127.0.0/16"

  tags = merge(local.tags, tomap({
    Name = local.vpc_name
  }))
}

###########################################
## networking
###########################################
resource "aws_route53_zone" "private" {
  name          = var.route_53_zone_name
  force_destroy = true

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = merge(local.tags, tomap({
    Name = var.route_53_zone_name
  }))
}

## security
module "my_ip" {
  source = "./my-ip"
}

resource "aws_security_group" "private" {
  name   = "travissaucier-${terraform.workspace}-private-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = [for x in module.subnets.public_subnet_cidrs : x]
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = [for x in module.subnets.public_subnet_cidrs : x]
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, tomap({
    Name = "travissaucier-${terraform.workspace}-sg"
  }))
}

resource "aws_security_group" "public" {
  name   = "travissaucier-${terraform.workspace}-public-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [for x in module.subnets.private_subnet_cidrs : x]
    #    security_groups = [aws_security_group.private.id]
  }

  tags = merge(local.tags, tomap({
    Name = "travissaucier-${terraform.workspace}-sg"
  }))
}

module "subnets" {
  source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets?ref=0.39.6"

  name      = "vpc"
  namespace = "travissaucier"
  stage     = terraform.workspace

  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block

  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = true

  tags = merge(local.tags, tomap({
    Name = local.vpc_name
  }))
}

###########################################
## elasticsearch
###########################################
module "elasticsearch" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticsearch?ref=0.33.1"

  namespace               = "travissaucier"
  stage                   = terraform.workspace
  name                    = "es"
  dns_zone_id             = aws_route53_zone.private.zone_id
  security_groups         = [aws_security_group.private.id]
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.subnets.private_subnet_ids
  zone_awareness_enabled  = "true"
  elasticsearch_version   = "6.5"
  instance_type           = "t2.medium.elasticsearch"
  instance_count          = 2
  ebs_volume_size         = 10
  iam_role_arns           = []
  iam_actions             = []
  encrypt_at_rest_enabled = false
  kibana_subdomain_name   = "kibana-es"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = merge(local.tags, tomap({
    Name = "travissaucier-${terraform.workspace}-es"
  }))
}

#module "alb" {
#  source = "git::https://github.com/cloudposse/terraform-aws-alb?ref=0.35.3"
#
#  namespace  = "travissaucier"
#  stage      = terraform.workspace
#  name       = "alb"
#  attributes = var.attributes
#  delimiter  = var.delimiter
#  vpc_id     = module.vpc.vpc_id
#  subnet_ids = module.subnets.public_subnet_ids
#
#  security_group_ids = [
#    aws_security_group.public.id
#  ]
#
#  access_logs_enabled                     = true
#  alb_access_logs_s3_bucket_force_destroy = true
#  cross_zone_load_balancing_enabled       = true
#
#  http2_enabled            = true
#  target_group_port        = 443
#  target_group_target_type = "instance"
#
#  tags = merge(local.tags, tomap({
#    Name = "travissaucier-${terraform.workspace}-alb"
#  }))
#}

###########################################
## bastion host
###########################################
module "aws_key_pair" {
  count  = 0
  source = "git::https://github.com/cloudposse/terraform-aws-key-pair?ref=0.18.0"

  attributes          = ["ssh", "key"]
  ssh_public_key_path = pathexpand("~/.ssh/aws_poc2_id_rsa")
  generate_ssh_key    = true

  context = module.this.context
}

module "ec2_bastion" {
  count   = 0
  source  = "git::https://github.com/cloudposse/terraform-aws-ec2-bastion-server"
  enabled = true

  namespace     = "travissaucier"
  stage         = terraform.workspace
  name          = "bastion"
  instance_type = "t2.micro"
  subnets       = module.subnets.public_subnet_ids
  key_name      = module.aws_key_pair[0].key_name
  user_data     = ["yum install -y postgresql-client-common"]
  vpc_id        = module.vpc.vpc_id
  context       = module.this.context
  zone_id       = aws_route53_zone.private.id

  associate_public_ip_address = true
  security_groups             = [module.vpc.vpc_default_security_group_id, aws_security_group.private.id]
  security_group_enabled      = true

  security_group_rules = [
    {
      "cidr_blocks" : [module.my_ip.ip_with_cidr],
      "description" : "Allow my ip inbound to 334 for port forwarding",
      "from_port" : 334,
      "protocol" : "tcp",
      "to_port" : 334,
      "type" : "ingress"
    },
    {
      "cidr_blocks" : [module.my_ip.ip_with_cidr],
      "description" : "Allow my ip inbound to SSH",
      "from_port" : 22,
      "protocol" : "tcp",
      "to_port" : 22,
      "type" : "ingress"
    },
    {
      "cidr_blocks" : ["0.0.0.0/0"],
      "description" : "Allow all outbound traffic",
      "from_port" : 0,
      "protocol" : -1,
      "to_port" : 0,
      "type" : "egress"
    }
  ]

  tags = merge(local.tags, tomap({
    Name = "travissaucier-${terraform.workspace}-bastion"
  }))
}
