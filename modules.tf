module "global" {
  source = "./modules/terraform-aws-premium-drawing-compensation-for-nylic-pdn-global"
  env    = var.env
  lob    = var.lob

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}

module "regional-us-east-1" {
  source                          = "./modules/terraform-aws-premium-drawing-compensation-for-nylic-pdn-regional"
  appid                           = var.appid
  env                             = var.env
  additional_vpc_cidrs_by_account = var.additional_vpc_cidrs_by_account
  green_instances                 = var.green_instances
  iam_instance_profile_name       = module.global.iam_instance_profile_name
  lob                             = var.lob
  tags                            = var.tags

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}
