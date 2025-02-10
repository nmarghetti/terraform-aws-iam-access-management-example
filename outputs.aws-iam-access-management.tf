output "aws_iam_users" {
  value = [for user in module.aws-iam-access-management.aws_iam_users : user.arn]
}

output "aws_iam_users_credentials" {
  description = "IAM users credentials"
  sensitive   = true
  value       = module.aws-iam-access-management.aws_iam_users_credentials
}

output "aws_secrets" {
  description = "Secrets stored in AWS Secrets Manager"
  value = { for key, secret in module.aws-iam-access-management.aws_secrets : key => {
    secrets = { for key, secret in secret.secrets : key => secret.arn }
    role    = secret.role.arn
  } }
}

output "aws_iam_groups" {
  description = "AWS IAM groups"
  value       = [for group in module.aws-iam-access-management.aws_iam_groups : group.arn]
}

output "aws_iam_roles" {
  description = "AWS IAM roles"
  value       = [for policy in module.aws-iam-access-management.aws_iam_roles : policy.arn]
}

output "aws_iam_policies" {
  description = "AWS IAM policies"
  value       = [for policy in module.aws-iam-access-management.aws_iam_policies : policy.arn]
}
