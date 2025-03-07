################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      version = ">= 5.0"
      source  = "hashicorp/aws"
    }
    random = {
      version = ">= 3.0"
      source  = "hashicorp/random"
    }
  }

}

data "aws_caller_identity" "current" {}

resource "aws_opensearchserverless_collection" "this" {
  name             = var.name
  description      = var.description
  standby_replicas = var.use_standby_replicas ? "ENABLED" : "DISABLED"
  type             = var.type
  tags             = var.tags
  depends_on       = [aws_opensearchserverless_security_policy.encryption]
}

######### encryption policy #########
resource "aws_opensearchserverless_security_policy" "encryption" {
  count       = var.create_encryption_policy ? 1 : 0
  name        = "${var.namespace}-${var.environment}-encryption"
  type        = "encryption"
  description = "Encryption policy for OpenSearch collection"
  policy = jsonencode(merge(
    {
      "Rules" = [
        {
          "Resource"     = ["collection/${var.name}"]
          "ResourceType" = "collection"
        }
      ],
    },
    {
      "AWSOwnedKey" = true
    }
  ))
}


########## Public access policy #########
resource "aws_opensearchserverless_security_policy" "public_network" {
  count       = var.enable_public_access ? 1 : 0
  name        = "${var.namespace}-${var.environment}-public-policy"
  type        = "network"
  description = "Public access policy for ${var.name}"
  policy = jsonencode([{
    "Rules" = [
      {
        "ResourceType" = "collection",
        "Resource"     = ["collection/${var.name}"]
      },
      {
        "ResourceType" = "dashboard",
        "Resource"     = ["collection/${var.name}"]
      },
    ],
    "AllowFromPublic" = true,
  }])
}

########## Private access policy #########
resource "aws_opensearchserverless_security_policy" "private_network" {
  count       = var.enable_public_access ? 0 : 1
  name        = "${var.namespace}-${var.environment}-private-policy"
  type        = "network"
  description = "Private VPC access policy for ${var.name}"
  policy = jsonencode([{
    "Rules" = [
      {
        "ResourceType" = "collection",
        "Resource"     = ["collection/${var.name}"]
      },
      {
        "ResourceType" = "dashboard",
        "Resource"     = ["collection/${var.name}"]
      }
    ],
    "AllowFromPublic" = false,
    "SourceVPCEs"     = [aws_opensearchserverless_vpc_endpoint.this[0].id],
  }])
}

########## VPC endpoint #########
resource "aws_opensearchserverless_vpc_endpoint" "this" {
  count              = var.enable_public_access ? 0 : 1
  name               = "${var.namespace}-${var.environment}-vpc-endpoint"
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.this[0].id]
}

########## access role #########
resource "aws_iam_role" "opensearch_access_role" {
  count = var.create_access_policy ? 1 : 0
  name  = "${var.namespace}-${var.environment}-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "es.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

########## role custom policy #########
resource "aws_iam_policy" "opensearch_custom_policy" {
  count       = var.create_access_policy ? 1 : 0
  name        = "${var.namespace}-${var.environment}-os-custompolicy"
  description = "Custom policy for OpenSearch Serverless access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "aoss:ReadDocument",
          "aoss:WriteDocument",
          "aoss:DescribeIndex",
          "aoss:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

########## role attachment policy #########
resource "aws_iam_role_policy_attachment" "opensearch_access_policy_attachment" {
  count      = var.create_access_policy ? 1 : 0
  role       = aws_iam_role.opensearch_access_role[0].name
  policy_arn = aws_iam_policy.opensearch_custom_policy[0].arn
}

########## access policy #########
resource "aws_opensearchserverless_access_policy" "this" {
  count       = var.create_access_policy ? 1 : 0
  name        = "${var.namespace}-${var.environment}-access-policy"
  type        = "data"
  description = "Network policy description"

  # Define the policy with required permissions
  policy = jsonencode([
    for rule in var.access_policy_rules : {
      "Rules" = [
        {
          "ResourceType" = rule.resource_type
          "Resource"     = rule.resource
          "Permission"   = rule.permissions
        }
      ],
      "Principal" = distinct(concat(["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.opensearch_access_role[0].name}"], rule.principal))
  }])
}

########## lifecycle policy #########
resource "aws_opensearchserverless_lifecycle_policy" "this" {
  count       = var.create_data_lifecycle_policy ? 1 : 0
  name        = "${var.namespace}-${var.environment}-data-policy"
  type        = "retention"
  description = "Data lifecycle policy description"
  policy = jsonencode({
    Rules = [
      for rule in var.data_lifecycle_policy_rules : {
        ResourceType      = "index",
        Resource          = [for index in rule.indexes : "index/${var.name}/${index}"],
        MinIndexRetention = rule.retention != "Unlimited" ? rule.retention : null
      }
    ]
  })
}

########### Security Group for serverless #########
resource "aws_security_group" "this" {
  count       = var.enable_public_access ? 0 : 1
  name        = var.security_group_name
  description = "Security group for the OpenSearch collection"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}
