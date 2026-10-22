locals {
  green_instances         = lookup(var.green_instances, data.aws_caller_identity.current.account_id, {})
  security_group_settings = local.security_group_settings_by_account[data.aws_caller_identity.current.account_id]

  additional_volumes = {
    node1 = {
      data = {
        device_name = "/dev/sdf"
        size        = 100
        type        = "gp3"
        snapshot_id = null
      }
    }

    node2 = {
      data = {
        device_name = "/dev/sdf"
        size        = 100
        type        = "gp3"
        snapshot_id = null
      }
    }
  }

  instance_tags = {
    "harness:autoStop" = "true"
    "nyl:backupTier"   = "Tier4"
  }

  security_group_settings_by_account = {
    "856115015560" = {
      "pdn_ssh_cidrs" = [
        "10.228.21.139/32",
        "10.228.27.132/32",
      ]

      "cyberark_rules" = {
        "ssh" = {
          "ip_protocol" = "tcp"
          "from_port"   = 22
          "to_port"     = 22

          "cidrs" = [
            "10.162.32.230/32",
            "10.162.32.231/32",
            "10.184.6.0/24",
            "10.186.29.0/24",
            "10.188.29.0/24",
            "10.41.16.143/32",
            "10.41.16.144/32",
            "10.41.16.145/32",
            "10.41.16.148/32",
            "10.41.16.53/32",
            "10.41.16.55/32",
            "10.41.20.47/32",
            "10.41.20.48/32",
            "10.41.24.198/32",
            "10.41.24.199/32",
            "10.41.28.41/32",
            "10.6.0.0/19",
            "10.6.86.193/32",
            "10.6.86.199/32",
            "10.6.94.135/32",
            "10.6.95.41/32",
            "10.6.95.42/32",
            "10.6.95.44/32",
            "10.7.0.0/19",
            "10.7.87.131/32",
            "10.7.94.254/32",
            "10.7.95.15/32",
            "10.7.95.16/32",
            "10.7.95.18/32",
            "10.73.16.103/32",
            "10.73.17.38/32",
            "10.73.17.59/32",
            "10.73.17.60/32",
            "10.73.17.61/32",
            "10.73.17.67/32",
            "10.73.20.100/32",
            "10.73.20.99/32",
            "10.73.24.116/32",
            "10.73.24.117/32",
            "10.73.28.21/32",
            "10.73.32.19/32",
            "10.73.32.30/32",
            "10.73.36.33/32",
          ]
        }

        "rpc" = {
          "ip_protocol" = "tcp"
          "from_port"   = 135
          "to_port"     = 135

          "cidrs" = [
            "10.41.16.148/32",
            "10.41.24.199/32",
            "10.6.0.0/19",
            "10.7.0.0/19",
            "10.73.17.67/32",
            "10.73.24.117/32",
          ]
        }

        "smb" = {
          "ip_protocol" = "tcp"
          "from_port"   = 445
          "to_port"     = 445

          "cidrs" = [
            "10.41.16.148/32",
            "10.41.24.199/32",
            "10.6.0.0/19",
            "10.7.0.0/19",
            "10.73.17.67/32",
            "10.73.24.117/32",
          ]
        }

        "rpc_high" = {
          "ip_protocol" = "tcp"
          "from_port"   = 1024
          "to_port"     = 65535

          "cidrs" = [
            "10.41.16.148/32",
            "10.41.24.199/32",
            "10.6.0.0/19",
            "10.7.0.0/19",
            "10.73.17.67/32",
            "10.73.24.117/32",
          ]
        }
      }

    }
  }

  subnet_ids_by_az = {
    for subnet in data.aws_subnet.compute : subnet.availability_zone => subnet.id
  }

  tags = merge(var.tags, {
    env     = var.env
    app_env = var.env
    lob     = var.lob
  })

  green_security_group_ids = toset([
    module.cyberark_instance_access_sg.resources.aws_security_group.id,
    module.pdn_instance_access_sg.resources.aws_security_group.id,
    module.vpc_access_sg.resources.aws_security_group.id,
  ])

  pdn_ingress = {
    for cidr in local.security_group_settings.pdn_ssh_cidrs : "ssh-${cidr}" => {
      description = "SSH from Blue PDN servers"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = cidr
    }
  }

  cyberark_ingress = merge([
    for key, rule in local.security_group_settings.cyberark_rules : {
      for cidr in rule.cidrs : "${key}-${cidr}" => {
        ip_protocol = rule.ip_protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr
      }
    }
  ]...)

  vpc_cidrs = setunion(
    toset(data.aws_vpc.current.cidr_block_associations[*].cidr_block),
    var.additional_vpc_cidrs,
  )

  vpc_ingress = {
    for cidr in local.vpc_cidrs : "all-${cidr}" => {
      ip_protocol = "-1"
      cidr_ipv4   = cidr
    }
  }
}
