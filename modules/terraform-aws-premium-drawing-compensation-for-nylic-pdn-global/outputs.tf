output "iam_instance_profile_name" {
  description = "IAM instance profile name."
  value       = module.green_instance_profile.aws_iam_instance_profile.name
}
