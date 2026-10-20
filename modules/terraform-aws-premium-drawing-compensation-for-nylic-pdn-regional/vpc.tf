data "aws_vpc" "current" {
  filter {
    name   = "tag:Name"
    values = ["nyl-${var.lob}-default-${var.env}-vpc"]
  }
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
