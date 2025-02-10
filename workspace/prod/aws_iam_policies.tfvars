aws_iam_policies = {
  aws-iam-create-access-key-str1 = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:CreateAccessKey",
            "Resource": "*"
        }
    ]
}
EOF
}
