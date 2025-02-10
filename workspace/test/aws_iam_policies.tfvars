aws_iam_policies = {
  access-cluster-test1 = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi"
            ],
            "Resource": "arn:aws:eks:*:*:cluster/test-*"
        }
    ]
}
EOF
}

aws_iam_existing_policies = {
}
