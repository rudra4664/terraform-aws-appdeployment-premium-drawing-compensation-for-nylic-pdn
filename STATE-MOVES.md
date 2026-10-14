# Existing state only

Do not add both alternatives. Review terraform state list first. A first deployment needs neither. Keep approved moved blocks in root moved.tf and inspect the plan for unexpected replacements.

## From the previously applied regional version

```hcl
moved {
  from = module.pdn_us_east_1.module.green_instance_profile
  to   = module.pdn_global.module.green_instance_profile
}

moved {
  from = module.pdn_us_east_1.data.aws_iam_policy_document.pdn_green
  to   = module.pdn_global.data.aws_iam_policy_document.pdn_green
}
```

The regional module label pdn_us_east_1 is retained, so its folder/source change does not itself change EC2/SG addresses.

## From the originally applied flat version

```hcl
moved {
  from = module.green_instance_profile_us_east_1
  to   = module.pdn_global.module.green_instance_profile
}

moved {
  from = module.green_instances_us_east_1
  to   = module.pdn_us_east_1.module.green_instances
}

moved {
  from = module.cyberark_instance_access_sg_us_east_1
  to   = module.pdn_us_east_1.module.cyberark_instance_access_sg
}

moved {
  from = module.pdn_instance_access_sg_us_east_1
  to   = module.pdn_us_east_1.module.pdn_instance_access_sg
}

moved {
  from = module.vpc_access_sg_us_east_1
  to   = module.pdn_us_east_1.module.vpc_access_sg
}
```
