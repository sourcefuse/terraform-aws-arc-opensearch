region               = "us-east-2"
engine_version       = "OpenSearch_2.15" 
instance_type        = "m5.large.search" 
instance_count       = 2    

# # Access policy as a Heredoc block
# access_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "*"
#       },
#       "Action": "es:*",
#       "Resource": "arn:aws:es:us-east-2:804295906245:domain/arc-opensearch-domain/*"
#     }
#   ]
# }
# POLICY