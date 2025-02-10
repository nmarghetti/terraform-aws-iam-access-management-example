aws_iam_users = {
  terraform-test1 = {
    create_iam_access_key = true
    force_destroy         = true
  },
  secret-manager-test1 = {
    create_iam_access_key = true
    force_destroy         = true
    groups                = ["developers-test1"]
  }
  developer-test1 = {
    create_iam_access_key = true
    force_destroy         = true
    groups                = ["developers-test1"]
  },
}

aws_iam_existing_users = {
  user1 = {
    groups       = ["developers-test1"]
    policy_names = ["aws-iam-change-password1"]
  }
  user2 = {}
  admin1 = {
    groups = ["developers-test1", "devops-test1"]
  }
  admin2 = {}
}

