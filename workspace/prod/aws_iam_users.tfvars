aws_iam_users = {
  # ROBOTIC USERS
  terraform-prod1 = {
    create_iam_access_key = true
    force_destroy         = true
  }

  # USERS
  user1 = {
    create_iam_user_login_profile : true
  }
  user2 = {
    create_iam_user_login_profile : true
    groups = ["default1"]
  }
  admin1 = {
    create_iam_user_login_profile : true
  }
  admin2 = {
    create_iam_user_login_profile : true
    groups = ["terraform-prod1"]
  }
}

aws_iam_existing_users = {}
