# Existing state only

Use only the alternative matching terraform state list. These are documentation snippets, not active Terraform. New deployments or committed-only code need no moved blocks. Never apply all alternatives together. Put the selected blocks in root moved.tf and review the client plan.

## From the previous global and regional split

```hcl
moved {
  from = module.pdn_global
  to   = module.global
}

moved {
  from = module.pdn_us_east_1
  to   = module.regional-us-east-1
}
```

## From the earlier regional-only version

```hcl
moved {
  from = module.pdn_us_east_1.module.green_instance_profile
  to   = module.global.module.green_instance_profile
}

moved {
  from = module.pdn_us_east_1
  to   = module.regional-us-east-1
}
```

## From the original flat version

```hcl
moved {
  from = module.green_instance_profile_us_east_1
  to   = module.global.module.green_instance_profile
}

moved {
  from = module.green_instances_us_east_1
  to   = module.regional-us-east-1.module.green_instances
}

moved {
  from = module.cyberark_instance_access_sg_us_east_1
  to   = module.regional-us-east-1.module.cyberark_instance_access_sg
}

moved {
  from = module.pdn_instance_access_sg_us_east_1
  to   = module.regional-us-east-1.module.pdn_instance_access_sg
}

moved {
  from = module.vpc_access_sg_us_east_1
  to   = module.regional-us-east-1.module.vpc_access_sg
}
```

Moves preserve addresses, not configuration parity. Custom policy removal, instance type and root disk type changes may produce further changes or replacements. Inspect the full plan before apply.
