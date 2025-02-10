output "aws_iam_policy_documents" {
  value = {
    aws-iam-create-access-key1 = data.aws_iam_policy_document.aws-iam-create-access-key1
  }
}
