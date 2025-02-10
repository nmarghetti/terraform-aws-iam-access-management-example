aws_iam_groups = {
  terraform-test1 = {
    policy_arns = [
      "arn:aws:iam::aws:policy/IAMFullAccess",
      "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
      "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    ]
    users = [
      "terraform-test1",
      "admin1",
      "admin2",
    ]
  },
  developers-test1 = {
    policy_arns = [
      "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
      "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
      "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly",
    ]
    policy_names = [
      "secret-list-test1",
      "access-cluster-test1",
    ]
    users = [
      "user1",
      "user2",
    ]
  }
  devops-test1 = {
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
      "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess",
    ]
    policy_names = [
      "secret-list-test1"
    ]
    users = [
      "admin1",
      "admin2",
    ]
  }
}

aws_iam_existing_groups = {
  default1 = {
    policy_names = ["aws-iam-change-password1"]
  }
}
