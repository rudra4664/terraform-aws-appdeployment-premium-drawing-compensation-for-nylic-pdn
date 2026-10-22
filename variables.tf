variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
  default     = "APP-511"
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "lob" {
  description = "Line of Business."
  type        = string
  default     = "corporatevs"
}

variable "tags" {
  description = "Application-specific tags shared by both green instances, merged on top of mandatory governance tags."
  type        = map(string)

  default = {
    appName        = "PDN"
    component      = "cmf-webserver"
    "map-migrated" = "mig40012"
    platform       = "aws"
    project        = "CloudMigration"
    provider       = "aws"
  }
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build, by AWS Account."

  type = map(map(object({
    availability_zone   = string
    name                = string
    strategic_os_type   = string
    strategic_ami_build = string
    root_volume_size    = number
  })))

  default = {
    "856115015560" = { # nyl-corporatevs-dev
      node1 = {
        availability_zone   = "us-east-1a"
        name                = "pdn-node-1-green"
        strategic_os_type   = "NYL Amazon Linux 2023"
        strategic_ami_build = "PROD"
        root_volume_size    = 100
      }

      node2 = {
        availability_zone   = "us-east-1b"
        name                = "pdn-node-2-green"
        strategic_os_type   = "NYL Amazon Linux 2023"
        strategic_ami_build = "PROD"
        root_volume_size    = 100
      }
    }
  }
}

variable "additional_vpc_cidrs" {
  description = "Additional VPC access source CIDRs by environment."
  type        = map(set(string))

  default = {
    dev = [
      "10.228.53.254/32",
    ]
  }
}
