#! /bin/bash

set -eo pipefail

cd "$(dirname "$(readlink -f "$0")")" || {
  echo "Unable to go to parent folder of $0" >&2
  exit 1
}

usage() {
  cat <<EOM >&2
Usage: $0 <plan|apply|import> [options] [<terraform arguments>, ...]

Mandatory options:
  -w, --workspace                         : workspace to use amongs $(terraform workspace list | tr -d '*' | awk '{ print $1 }' | grep -E '[a-zA-Z]' | grep -vFx 'default' | tr '\n' ',' | head -c -1)

Options:
  -h                                      : display this help
  -d, --debug                             : enable debug mode

EOM
}

LOG_DEBUG=${LOG_DEBUG:-1}

command="$1"
shift
[ -z "$command" ] && {
  echo "Error: command is required." >&2
  usage
  exit 1
}
case "$command" in
  apply | plan | import | output) ;;
  -h | --help | help)
    usage
    exit 0
    ;;
  *)
    echo "Error: unsupported command '$command'" >&2
    usage
    exit 1
    ;;
esac

workspace=
# reset getopts - check https://man.cx/getopts(1)
OPTIND=1
while getopts "dhw:-:" opt; do
  case "$opt" in
    d) LOG_DEBUG=1 ;;
    w) workspace="$OPTARG" ;;
    h)
      usage
      exit 0
      ;;
    -)
      case "$OPTARG" in
        help)
          usage
          exit 0
          ;;
        debug) LOG_DEBUG=1 ;;
        workspace)
          workspace="${!OPTIND}"
          OPTIND=$((OPTIND + 1))
          ;;
        *)
          echo "Unknow option $OPTARG"
          usage
          exit 1
          ;;
      esac
      ;;
    \? | *)
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))
[ -z "$workspace" ] && {
  echo "Error: workspace is required." >&2
  usage
  exit 1
}

. ./scripts/utils/log.sh
[ ! -f ./terraform.env.sh ] || . ./terraform.env.sh

run_command terraform workspace select "$workspace" >&2 || exit_error "Unable to select workspace $workspace"

terraform_state="./terraform.tfstate.d/$(terraform workspace show)/terraform.tfstate"

case $command in
  apply | plan | import)
    # PGP key to encrypt credentials
    [ -z "$PGP_KEY" ] && exit_error "PGP_KEY is empty"
    TF_VAR_pgp_key="$(run_command gpg --export "$PGP_KEY" | run_command_piped base64)"
    [ -z "$TF_VAR_pgp_key" ] && exit_error "gpg key '$PGP_KEY' not found"
    export TF_VAR_pgp_key

    # AWS credentials
    if [ -f "$terraform_state" ]; then
      export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-$(jq -r '.outputs.aws_iam_users_credentials.value.["'"$(jq -r '.outputs.aws_iam_users_credentials.value // {} | keys | .[]' <"$terraform_state" | grep terraform | grep "$workspace")"'"].iam_access_key_id' <"$terraform_state")}"
      export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-$(jq -r '.outputs.aws_iam_users_credentials.value.["'"$(jq -r '.outputs.aws_iam_users_credentials.value // {} | keys | .[]' <"$terraform_state" | grep terraform | grep "$workspace")"'"].secret_access_key' <"$terraform_state" | gpg --decrypt 2>/dev/null)}"
    fi
    export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-west-1}"
    [ -z "$AWS_ACCESS_KEY_ID" ] && exit_error "AWS_ACCESS_KEY_ID is empty"
    [ -z "$AWS_SECRET_ACCESS_KEY" ] && exit_error "AWS_SECRET_ACCESS_KEY is empty"

    # Current AWS account id
    aws_caller_identity="$(run_command aws sts get-caller-identity)"
    TF_VAR_aws_account_id="$(echo "$aws_caller_identity" | run_command_piped jq -r '.Account')"
    [ -z "$TF_VAR_aws_account_id" ] && exit_error "Error getting AWS account id"
    export TF_VAR_aws_account_id

    log_info "Running with user: $(echo "$aws_caller_identity" | jq -r '.Arn')"

    tf_vars=()
    while read -r var; do
      tf_vars+=("-var-file" "$var")
    done < <(find ./workspace/"$workspace" -mindepth 1 -maxdepth 1 -type f -name '*.tfvars')

    run_command terraform "$command" "${tf_vars[@]}" "$@"
    ;;
  output)
    run_command terraform output --state "$terraform_state" "$@"
    ;;
  *) exit_error "Unsupported command '$command'" ;;
esac
