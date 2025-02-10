variable "workspace" {
  description = "The name of the workspace, this would ensure that the resources are created in the correct environment. It has to match the current selected terraform workspace"
  validation {
    condition     = var.workspace == terraform.workspace
    error_message = "[Error] You are trying to deploy '${var.workspace}' config while using '${terraform.workspace}' terraform workspace.\nPlease switch terraform workspace or variables config file.\nterraform workspace select ${var.workspace}"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "pgp_key" {
  description = "value of the pgp key to encrypt the secrets"
  type        = string
}

locals {
  # Ensure to at least have project and environment as tags
  tags = merge({
    project             = "terraform-aws-iam-access-management-example"
    source              = "terraform"
    terraform-repo      = "https://github.com/nmarghetti/terraform-aws-iam-access-management-example"
    terraform-workspace = terraform.workspace
  }, var.tags)

  aws_iam_policy_documents = terraform.workspace == "test" ? module.aws_iam_policy_documents_test[0].aws_iam_policy_documents : terraform.workspace == "prod" ? module.aws_iam_policy_documents_prod[0].aws_iam_policy_documents : {}
}
