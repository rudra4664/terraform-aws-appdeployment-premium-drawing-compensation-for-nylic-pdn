data "aws_vpcs" "current" {
}

data "aws_vpc" "current" {
  id = one(data.aws_vpcs.current.ids)
}

data "aws_subnets" "compute" {
  tags = {
    tier = "compute"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }
}

data "aws_subnet" "compute" {
  for_each = toset(data.aws_subnets.compute.ids)
  id       = each.value
}
