data "aws_iam_policy_document" "secret-list-test1" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["arn:aws:secretsmanager:eu-west-1:${var.aws_account_id}:secret:external-secrets-test-*"]
  }
}
data "aws_iam_policy_document" "aws-iam-change-password1" {
  statement {
    effect    = "Allow"
    actions   = ["iam:ChangePassword"]
    resources = ["*"]
  }
}
