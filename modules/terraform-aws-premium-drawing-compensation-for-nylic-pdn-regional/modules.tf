module "pdn_instance_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.1.3"
  tf_org  = "NYL-Prod"
  appid   = var.appid
  tags    = local.tags

  security_group = {
    name_prefix = "pdn-green-inbound-access-"
    description = "SSH access for PDN"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.pdn_ingress
    egress      = {}
  }
}

module "cyberark_instance_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.1.3"
  tf_org  = "NYL-Prod"
  appid   = var.appid
  tags    = local.tags

  security_group = {
    name_prefix = "pdn-green-cyberark-access-"
    description = "CyberArk access for PDN"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.cyberark_ingress
    egress      = {}
  }
}

module "vpc_access_sg" {
  source  = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-security-group"
  version = "1.1.3"
  tf_org  = "NYL-Prod"
  appid   = var.appid
  tags    = local.tags

  security_group = {
    name_prefix = "pdn-green-vpc-access-"
    description = "Access within the VPC and approved additional sources"
    vpc_id      = data.aws_vpc.current.id
    ingress     = local.vpc_ingress

    egress = {
      all_outbound = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }
}

module "green_instances" {
  for_each           = local.green_instances
  source             = "app.terraform.io/NYL-Prod/apps-resources/aws//modules/terraform-aws-ec2-instance"
  version            = "1.1.3"
  tf_org             = "NYL-Prod"
  appid              = var.appid
  env                = var.env
  lob                = var.lob
  kms_key_id         = data.aws_kms_alias.default.arn
  additional_volumes = local.additional_volumes[each.key]

  tags = merge(local.tags, local.instance_tags, {
    Name                  = each.value.name
    TerraformResourceName = each.value.name
  })

  instance = {
    iam_instance_profile = var.iam_instance_profile_name
    instance_type        = "t3a.medium"
    key_name             = var.key_name
    monitoring           = false
    name                 = each.value.name
    strategic_os_type    = each.value.strategic_os_type
    strategic_ami_build  = each.value.strategic_ami_build

    root_volume = {
      size = each.value.root_volume_size
      type = "gp3"
    }
  }

  network = {
    subnet_id          = local.subnet_ids_by_az[each.value.availability_zone]
    security_group_ids = local.green_security_group_ids
  }
}
