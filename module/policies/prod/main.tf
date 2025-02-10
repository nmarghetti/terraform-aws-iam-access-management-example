data "aws_iam_policy_document" "aws-iam-create-access-key1" {
  statement {
    effect    = "Allow"
    actions   = ["iam:CreateAccessKey"]
    resources = ["*"]
  }
}
