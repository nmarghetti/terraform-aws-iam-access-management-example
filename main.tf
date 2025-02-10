module "aws_iam_policy_documents_test" {
  count          = terraform.workspace == "test" ? 1 : 0
  source         = "./module/policies/test"
  aws_account_id = var.aws_account_id
}

module "aws_iam_policy_documents_prod" {
  count          = terraform.workspace == "prod" ? 1 : 0
  source         = "./module/policies/prod"
  aws_account_id = var.aws_account_id
}

module "aws-iam-access-management" {
  # source = "../terraform-aws-iam-access-management"
  source  = "nmarghetti/iam-access-management/aws"
  version = "1.1.2"

  tags    = local.tags
  pgp_key = var.pgp_key

  # aws_iam_policies          = { for key, policy in var.aws_iam_policies : key => replace(policy, "$${terraform.aws_account_id}", var.aws_account_id) }
  # aws_iam_policy_documents  = local.aws_iam_policy_documents
  # aws_iam_existing_policies = var.aws_iam_existing_policies
  # aws_iam_users             = var.aws_iam_users
  # aws_iam_existing_users    = var.aws_iam_existing_users
  # aws_iam_groups            = var.aws_iam_groups
  # aws_iam_existing_groups   = var.aws_iam_existing_groups
  # aws_iam_roles             = var.aws_iam_roles

  aws_iam_policies          = {}
  aws_iam_policy_documents  = {}
  aws_iam_existing_policies = {}
  aws_iam_users             = {}
  aws_iam_existing_users    = {}
  aws_iam_groups            = {}
  aws_iam_existing_groups   = {}
  aws_iam_roles             = {}

  # aws_secrets               = var.aws_secrets
  # aws_ecr_repositories      = var.aws_ecr_repositories
}

# resource "aws_eks_identity_provider_config" "eks" {
# }
