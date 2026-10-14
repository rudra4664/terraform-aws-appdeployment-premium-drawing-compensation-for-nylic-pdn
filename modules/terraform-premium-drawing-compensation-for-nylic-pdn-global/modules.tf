module "green_instance_profile" {
  source           = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-instance-profile-standard"
  version          = "1.0.9"
  tf_org           = "NYL-Prod"
  env              = var.env
  lob              = var.lob
  name             = "PdnGreenInstanceProfile"
  organization_id  = "o-m8cxcbau0l"
  custom_policy    = data.aws_iam_policy_document.pdn_green.json
  managed_policies = ["AmazonRDSFullAccess"]
}
