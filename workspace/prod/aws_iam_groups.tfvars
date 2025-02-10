aws_iam_groups = {
  terraform-prod1 = {
    policy_arns = [
      "arn:aws:iam::aws:policy/IAMFullAccess",
      "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
      "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    ]
    users = [
      "terraform-prod1",
      "admin1",
      "admin2",
    ]
  }


  default1 = {
    policy_arns = [
      "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
    ]
    policy_names = [
      "aws-iam-create-access-key1",
    ]
    users = [
      "user1",
      "user2",
    ]
  }
}
