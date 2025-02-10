#! /bin/sh

cd "$(dirname "$(readlink -f "$0")")/.." || {
  echo "Unable to go to parent parent folder of $0" >&2
  exit 1
}

for ws in $(terraform workspace list | tr -d '*' | awk '{ print $1 }' | sed '/^$/d' | grep -vFx default); do
  echo "$ws"
  input="./terraform.tfstate.d/$ws/terraform.tfstate"
  for arn in $(terraform output -state "$input" -json aws_iam_users | jq -r '.[]'); do
    user=$(basename "$arn")
    echo "  * $user"
    data=$(jq -r '.outputs.aws_iam_users_credentials.value.["'"$user"'"].iam_access_key_id' <"$input" | grep -vFx 'null')
    [ -n "$data" ] && echo "    - AWS_ACCESS_KEY_ID=$data"
    data=$(jq -r '.outputs.aws_iam_users_credentials.value.["'"$user"'"].secret_access_key' <"$input" | gpg --decrypt 2>/dev/null)
    [ -n "$data" ] && echo "    - AWS_SECRET_ACCESS_KEY=$data"
    data=$(jq -r '.outputs.aws_iam_users_credentials.value.["'"$user"'"].password' <"$input" | gpg --decrypt 2>/dev/null)
    [ -n "$data" ] && echo "    - password=$data"
  done
  echo
done
