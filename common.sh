#!/usr/bin/env bash
set -euo pipefail

BROKER_ORG="${BROKER_ORG:-NexTrade-Broker-Platform}"
BROKER_BRANCH="${BROKER_BRANCH:-main}"
BROKER_BASE_URL="${BROKER_BASE_URL:-https://github.com/${BROKER_ORG}}"

BROKER_REPOS=(
  frontend
  api-gateway
  auth-service
  wallet-service
  notification-service
  order-service
  portfolio-service
  fee-service
)

UPDATE=false
DETACH="-d"

for arg in "$@"; do
  case "$arg" in
    --update) UPDATE=true ;;
    --foreground) DETACH="" ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

clone_or_pull() {
  local repo_name="$1"
  local folder="$2"
  local repo_url="${BROKER_BASE_URL}/${repo_name}.git"

  if [ -d "${folder}/.git" ]; then
    echo "Pulling ${folder} from ${BROKER_BRANCH}..."
    git -C "${folder}" fetch origin
    git -C "${folder}" checkout "${BROKER_BRANCH}"
    git -C "${folder}" pull origin "${BROKER_BRANCH}"
  else
    echo "Cloning ${repo_name} branch ${BROKER_BRANCH} into ${folder}..."
    git clone --branch "${BROKER_BRANCH}" "${repo_url}" "${folder}"
  fi
}

update_broker_repos_if_requested() {
  echo "Using broker GitHub organization: ${BROKER_ORG}"
  echo "Using broker branch: ${BROKER_BRANCH}"

  if [ "${UPDATE}" = true ]; then
    for repo in "${BROKER_REPOS[@]}"; do
      clone_or_pull "${repo}" "${repo}"
    done
  else
    echo "Skipping repository update. Use --update to clone/pull repositories."
  fi
}

ensure_env_file() {
  if [ ! -f .env ]; then
    echo "Missing .env. Creating it from env/.env.example..."
    cp env/.env.example .env
    echo "Edit .env before using real credentials."
  fi
}
