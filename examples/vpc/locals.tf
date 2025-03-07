locals {
  private_subnet_ids = [for s in data.aws_subnet.private : s.id]

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  ## OpenSearch Serverless Domain
  access_policy_rules = [
    {
      resource_type = "collection"
      resource      = ["collection/${var.name}"]
      permissions   = ["aoss:CreateCollectionItems", "aoss:DeleteCollectionItems", "aoss:UpdateCollectionItems", "aoss:DescribeCollectionItems"]
    },
  ]

  data_lifecycle_policy_rules = [
    {
      indexes   = ["index1", "index2"]
      retention = "30d"
    },
    {
      indexes   = ["index3"]
      retention = "24h"
    }
  ]
}
