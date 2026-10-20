data "aws_vpc" "current" {
  provider = aws.us-east-1
  filter {
    name   = "tag:Name"
    values = ["nyl-${var.lob}-default-${var.env}-vpc"]
  }
}

data "aws_subnets" "compute" {
  provider = aws.us-east-1
  tags = {
    tier = "compute"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }
}

data "aws_subnet" "compute" {
  provider = aws.us-east-1
  for_each = toset(data.aws_subnets.compute.ids)
  id       = each.value
}
