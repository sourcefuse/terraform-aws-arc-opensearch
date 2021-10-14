###########################################
## defaults / versions / providers
###########################################
terraform {
  required_version = ">= 1.0.8"

  backend "s3" {
    region         = "us-east-1"
    key            = "terraform-aws-opensearch/terraform.tfstate"
    bucket         = "sf-ref-arch-terraform-state-dev"
    dynamodb_table = "sf_ref_arch_terraform_state_dev"
    encrypt        = true
    role_arn       = "arn:aws:iam::757583164619:role/sourcefuse-poc-2-user-role"
  }

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
## imports / lookups
###########################################
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.base_name}-vpc"]
  }
}

## network
data "aws_subnet" "private" {
  for_each = toset(var.availability_zones)

  vpc_id   = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["refarch-${terraform.workspace}-privatesubnet-private-${each.key}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.availability_zones)

  vpc_id   = data.aws_vpc.this.id

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

###########################################
## networking / security
###########################################
module "travis_ip" {
  source = "./my-ip"
}

resource "aws_security_group" "private" {
  name   = "${local.base_name}-private-sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = local.public_subnets_cidr_block
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = local.public_subnets_cidr_block
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-private-sg"
  }))
}

resource "aws_security_group" "public" {
  name   = "${local.base_name}-public-sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.travis_ip.ip_with_cidr]
#    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.travis_ip.ip_with_cidr]
    #    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.private_subnets_cidr_block
    #    security_groups = [aws_security_group.private.id]
  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-public-sg"
  }))
}

###########################################
## elasticsearch
###########################################
resource "aws_iam_role" "this" {
  name = "ec2Assume"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

#  inline_policy {
#    name = "esAllow"
#    policy = jsonencode({
#      Statement = [
#        {
#          Action = "es:*"
#          Effect = "Allow"
#          Principal = {
#            AWS = "*"
#          }
#        },
#      ]
#    })
#  }
}

module "elasticsearch" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticsearch?ref=0.33.1"

  namespace               = "refarch"
  stage                   = terraform.workspace
  name                    = "es"
  security_groups         = [aws_security_group.private.id]
  vpc_id                  = data.aws_vpc.this.id
  subnet_ids              = data.aws_subnet_ids.private.ids
  zone_awareness_enabled  = "true"
  elasticsearch_version   = "6.8"
  instance_type           = "t2.medium.elasticsearch"
  instance_count          = 2
  ebs_volume_size         = 10
  iam_role_arns           = [aws_iam_role.this.arn]
  iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  encrypt_at_rest_enabled = false
  kibana_subdomain_name   = "kibana-es"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-es"
  }))
}


###########################################
## bastion host
###########################################
module "aws_key_pair" {
  count  = 1
  source = "git::https://github.com/cloudposse/terraform-aws-key-pair?ref=0.18.0"

  attributes          = ["ssh", "key"]
  ssh_public_key_path = pathexpand("~/.ssh/aws_poc2_id_rsa")
  generate_ssh_key    = true

  context = module.this.context
}

module "ec2_bastion" {
  count   = 1
  source  = "git::https://github.com/cloudposse/terraform-aws-ec2-bastion-server"
  enabled = true

  namespace     = "travissaucier"
  stage         = terraform.workspace
  name          = "bastion"
  instance_type = "t2.micro"
  subnets       = data.aws_subnet_ids.public.ids
  key_name      = module.aws_key_pair[0].key_name
  user_data     = [
    "yum update",
    "yum install -y jq curl"
  ]
  vpc_id        = data.aws_vpc.this.id
  context       = module.this.context

  associate_public_ip_address = true
  security_groups             = [
    aws_security_group.public.id,
    aws_security_group.private.id
  ]
  security_group_enabled      = true

  security_group_rules = [
    {
      "cidr_blocks" : [module.travis_ip.ip_with_cidr],
      "description" : "Allow my ip inbound to 334 for port forwarding",
      "from_port" : 334,
      "protocol" : "tcp",
      "to_port" : 334,
      "type" : "ingress"
    },
    {
      "cidr_blocks" : [module.travis_ip.ip_with_cidr],
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


################################################
## load balancer
################################################
/*
resource "aws_lb_target_group" "es_tg" {
  name        = "${local.base_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.this.id
}

resource "aws_lb" "alb" {
  name               = "${local.base_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = local.public_subnet_id

  enable_deletion_protection = false

#  access_logs {
#    bucket  = null
#    prefix  = "${local.base_name}-alb"
#    enabled = false
#  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-alb"
  }))
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

*/

/*
module "alb" {
  source = "git::https://github.com/cloudposse/terraform-aws-alb?ref=0.35.3"

  namespace  = "refarch"
  stage      = terraform.workspace
  name       = "alb"
  attributes = var.attributes
  delimiter  = var.delimiter
  vpc_id     = data.aws_vpc.this.id
  subnet_ids = module.subnets.public_subnet_ids

  security_group_ids = [
    aws_security_group.public.id
  ]

  access_logs_enabled                     = true
  alb_access_logs_s3_bucket_force_destroy = true
  cross_zone_load_balancing_enabled       = true

  http2_enabled            = true
  target_group_port        = 443
  target_group_target_type = "instance"

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-alb"
  }))
}
*/
