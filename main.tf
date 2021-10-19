###########################################
## networking / security
###########################################
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
    cidr_blocks = local.inbound_public_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.inbound_public_cidrs
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
data "aws_iam_policy_document" "es_full_access" {
  statement {
    sid    = "esFullAccess"
    effect = "Allow"
    #    resources = ["${module.elasticsearch.domain_arn}/*", "*"]
    resources = ["*"]

    actions = [
      "es:*",
      "es:ESHttp*",
      "*"
    ]
  }
}

resource "random_password" "admin_password" {
  length = 32
}

module "elasticsearch" {
  source = "git::https://github.com/cloudposse/terraform-aws-elasticsearch?ref=0.33.1"

  namespace                       = var.namespace
  stage                           = terraform.workspace
  name                            = "es"
  security_groups                 = [aws_security_group.private.id]
  vpc_id                          = data.aws_vpc.this.id
  subnet_ids                      = data.aws_subnet_ids.private.ids
  zone_awareness_enabled          = "true"
  elasticsearch_version           = "OpenSearch_1.0"
  instance_type                   = "t3.medium.elasticsearch"
  instance_count                  = 2
  ebs_volume_size                 = 10
  iam_role_arns                   = ["*"]
  iam_actions                     = ["es:*"]
  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true
  kibana_subdomain_name           = "kibana-es"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    override_main_response_version           = false
  }

  tags = merge(local.tags, tomap({
    Name = "${local.base_name}-es"
  }))

  //TODO: make these configurable
  advanced_security_options_enabled                        = true
  advanced_security_options_internal_user_database_enabled = true
  advanced_security_options_master_user_name               = var.admin_username
  advanced_security_options_master_user_password           = random_password.admin_password.result
  cognito_authentication_enabled                           = false
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

  namespace     = var.namespace
  stage         = terraform.workspace
  name          = "bastion"
  instance_type = "t2.micro"
  subnets       = data.aws_subnet_ids.public.ids
  key_name      = module.aws_key_pair[0].key_name
  vpc_id        = data.aws_vpc.this.id
  context       = module.this.context

  security_group_enabled      = true
  associate_public_ip_address = true

  user_data = [
    "yum update",
    "yum install -y jq curl"
  ]

  security_groups = [
    aws_security_group.public.id,
    aws_security_group.private.id
  ]

  security_group_rules = [
    {
      "cidr_blocks" : local.inbound_public_cidrs,
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


resource "aws_ssm_parameter" "this" {
  for_each = { for x in local.ssm_params : x.name => x }

  name      = lookup(each.value, "name", null)
  value     = lookup(each.value, "value", null)
  type      = lookup(each.value, "type", null)
  overwrite = true

  tags = local.tags
}
