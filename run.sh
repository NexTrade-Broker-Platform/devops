#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

BROKER_ORG="${BROKER_ORG:-NexTrade-Broker-Platform}"
BROKER_BRANCH="${BROKER_BRANCH:-main}"
DETACH="${DETACH:--d}"
UPDATE=false

for arg in "$@"; do
  case "$arg" in
    --update) UPDATE=true ;;
    --foreground) DETACH="" ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

repos=(
  frontend
  api-gateway
  auth-service
  wallet-service
  order-service
  portfolio-service
  fee-service
  notification-service
)

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "Created .env from .env.example. Review it if needed, then rerun."
    exit 1
  else
    echo "Missing .env and .env.example"
    exit 1
  fi
fi

if [ "$UPDATE" = true ]; then
  for repo in "${repos[@]}"; do
    if [ -d "$repo/.git" ]; then
      echo "Updating $repo..."
      git -C "$repo" fetch origin "$BROKER_BRANCH"
      git -C "$repo" checkout "$BROKER_BRANCH"
      git -C "$repo" pull --ff-only origin "$BROKER_BRANCH"
    else
      echo "Cloning $repo branch $BROKER_BRANCH..."
      git clone --branch "$BROKER_BRANCH" "https://github.com/${BROKER_ORG}/${repo}.git" "$repo"
    fi
  done
else
  echo "Skipping repository update. Use --update to clone/pull repositories."
fi

echo "Starting NexTrade broker only..."
docker compose --env-file .env -f docker-compose.yml up --build ${DETACH}
