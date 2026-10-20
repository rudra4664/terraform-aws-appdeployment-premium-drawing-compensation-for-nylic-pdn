data "aws_kms_alias" "default" {
  provider = aws.us-east-1
  name     = "alias/default"
}
