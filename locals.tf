locals {
  ## secrets
  advanced_security_options_master_user_password = try(random_password.admin_password[0].result, var.custom_opensearch_password)

  ## ssm
  ssm_param_base_name = "/${var.namespace}/${var.environment}/opensearch"
  ssm_params = [
    {
      name  = "${local.ssm_param_base_name}/admin_username"
      value = var.admin_username
      type  = "String"
    },
    {
      name  = "${local.ssm_param_base_name}/admin_password"
      value = local.advanced_security_options_master_user_password
      type  = "SecureString"
    },
  ]

  ## iam
  admin_iam_role_policy_arn_attachments = ["arn:aws:iam::aws:policy/AmazonOpenSearchServiceFullAccess"]
  ro_iam_role_policy_arn_attachments    = ["arn:aws:iam::aws:policy/AmazonOpenSearchServiceReadOnlyAccess"]
}
