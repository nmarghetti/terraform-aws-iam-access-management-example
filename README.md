# terraform-aws-iam-access-management-example

## Init repository

```shell
# Init submodules
git submodule update --init
cd scripts/utils &&
  git sparse-checkout set --no-cone '/log.sh' &&
  cd -

# Upgrade submodules
git submodule update --remote
```

## Encryption

### GPG

- Import `gpg_name` gpg key

  ```shell
  # Ask for an admin to provide you the key and import it
  gpg --import gpg_name_public_key.asc
  gpg --import gpg_name_private_key.asc
  ```

- How it has been created

  DO NOT CREATE IT AGAIN !!!

  ```shell
  # Either create private and public gpg key with prompt
  gpg --full-generate-key

  # Either automate it
  # Generate GPG key if not already done
  if ! gpg --list-keys "gpg_name" >/dev/null 2>&1; then
    cat >./gen-key-script <<EOF
  %no-protection
  Key-Type: RSA
  Key-Length: 4096
  Subkey-Type: RSA
  Subkey-Length: 4096
  Name-Real: gpg_name
  Name-Email: no-reply@gpg_name.com
  Expire-Date: 0
  %commit
  EOF
    gpg --batch --generate-key ./gen-key-script
    rm -f ./gen-key-script
  fi

  # Export public key
  gpg --export --armor gpg_name >gpg_name_public_key.asc
  # Export private key
  gpg --export-secret-keys --armor gpg_name >gpg_name_private_key.asc
  ```

## Terraform cli

### Workspaces

```shell
# List
terraform workspace list
# Select
terraform workspace select test
terraform workspace select prod
# Create
terraform workspace new <PUT_NAME>
```

### Init

```shell
# Initialize terraform modules etc., needed every times a module/provider version is changed
terraform init
```

### Compute variables.aws-iam-access-management.tf

```shell
# if local module
../terraform-aws-iam-access-management/variables.sh >variables.aws-iam-access-management.tf
# if online
./.terraform/modules/aws-iam-access-management/variables.sh >variables.aws-iam-access-management.tf
```

### ./terraform.sh

./terraform.sh is a tiny wrapper around terraform to:

- avoid applying wrong variables to the wrong workspace
- automatically retrieve/decrypt AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY of terraform-<workspace> AWS user
- use your own AWS credentials if you prefer not to use terraform-<workspace> user
- output all commands ran if you activate debug mode

```shell
# Display usage
./terraform.sh -h
# Plan test workspace using your AWS credential
AWS_ACCESS_KEY_ID="YOUR ACCESS KEY" AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY" ./terraform.sh plan -w test
# Plan test workspace using terraform-test user credential
./terraform.sh plan -w test
# Same as above but also print the commands ran
./terraform.sh plan -w test -d
```

### Plan

```shell
# Plan to a workspace
./terraform.sh plan -w test
./terraform.sh plan -w prod
```

### Apply

```shell
# Apply to a workspace
./terraform.sh apply -w test
./terraform.sh apply -w prod
# Apply to a workspace with auto approve (be careful)
./terraform.sh apply -w test -- -auto-approve
./terraform.sh apply -w prod -- -auto-approve

# You might need to select only some target as others can depend on it
./terraform.sh plan -w test -- -target=module.aws.data.aws_iam_users.iam_users -out=./terraform.plan
./terraform.sh plan -w prod -- -target=module.aws.data.aws_iam_users.iam_users -out=./terraform.plan
# Apply the plan
terraform apply ./terraform.plan
```

### Import

```shell
# Import resource
./terraform.sh import -w prod -- module.aws-iam-access-management.aws_ecr_repository.ecr_repository[\"some-ecr\"] some-ecr
```

### Taint

```shell
# Taint deleted resource to recreate them
terraform taint module.aws-iam-access-management.aws_ecr_repository.ecr_repository[\"some-ecr\"]
```

### Remove

```shell
# Remove resource from local state
terraform state rm module.aws-iam-access-management.aws_ecr_repository.ecr_repository[\"some-ecr\"]
```

### Output

```shell
# Display full output
terraform output
./terraform.sh output -w test
# Display one output
terraform output aws_secrets
./terraform.sh output -w test -- -json aws_secrets | jq '.["external-secrets-test"]'
```
