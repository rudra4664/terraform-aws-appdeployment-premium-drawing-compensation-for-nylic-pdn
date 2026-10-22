variable "appid" {
  description = "Application ID governance tag. Must begin with APP-."
  type        = string
}

variable "env" {
  description = "Environment (dev, qa, stage, prod or test)."
  type        = string
}

variable "green_instances" {
  description = "Green (OS-upgraded) instances to build, by AWS Account."

  type = map(map(object({
    availability_zone   = string
    name                = string
    root_volume_size    = number
    strategic_ami_build = string
    strategic_os_type   = string
  })))
}

variable "lob" {
  description = "Line of Business."
  type        = string
}

variable "tags" {
  description = "Application-specific tags merged on top of mandatory governance tags."
  type        = map(string)
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name."
  type        = string
}

variable "additional_vpc_cidrs" {
  description = "Additional VPC access source CIDRs."
  type        = set(string)
}
