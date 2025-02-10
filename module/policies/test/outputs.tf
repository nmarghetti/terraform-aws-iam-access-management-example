
output "aws_iam_policy_documents" {
  value = {
    secret-list-test1        = data.aws_iam_policy_document.secret-list-test1
    aws-iam-change-password1 = data.aws_iam_policy_document.aws-iam-change-password1
  }
}
