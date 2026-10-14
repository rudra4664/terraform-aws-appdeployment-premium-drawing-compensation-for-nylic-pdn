module "pdn_global" {
  source = "./modules/terraform-premium-drawing-compensation-for-nylic-pdn-global"
  env    = var.env
  lob    = var.lob

  providers = {
    aws = aws.us-east-1
  }
}

module "pdn_us_east_1" {
  source                    = "./modules/terraform-premium-drawing-compensation-for-nylic-pdn-regional"
  appid                     = var.appid
  env                       = var.env
  green_instances           = var.green_instances
  iam_instance_profile_name = module.pdn_global.iam_instance_profile_name
  lob                       = var.lob
  tags                      = var.tags

  providers = {
    aws = aws.us-east-1
  }
}
