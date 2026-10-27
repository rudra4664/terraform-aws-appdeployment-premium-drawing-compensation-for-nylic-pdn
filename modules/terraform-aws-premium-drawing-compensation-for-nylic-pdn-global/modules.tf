module "green_instance_profile" {
  source           = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-instance-profile-standard"
  version          = "1.1.3"
  tf_org           = "NYL-Prod"
  env              = var.env
  lob              = var.lob
  name             = "PdnGreenInstanceProfile"
  managed_policies = []
}
