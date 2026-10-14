data "aws_iam_policy_document" "pdn_green" {
  statement {
    sid    = "S3BucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      for bucket in local.s3_bucket_names :
      "arn:aws:s3:::${bucket}"
    ]
  }

  statement {
    sid    = "KMSAccess"
    effect = "Allow"

    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:Describe*",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:List*",
      "kms:ReEncrypt*",
      "kms:RevokeGrant",
    ]

    resources = ["*"]
  }
}
