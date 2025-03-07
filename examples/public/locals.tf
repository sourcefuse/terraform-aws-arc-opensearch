locals {

  ## OpenSearch Serverless Domain
  access_policy_rules = [
    {
      resource_type = "collection"
      resource      = ["collection/${var.name}"]
      permissions   = ["aoss:CreateCollectionItems", "aoss:DeleteCollectionItems", "aoss:UpdateCollectionItems", "aoss:DescribeCollectionItems"]
      principal     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/arc-poc-user"]
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
