#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh "$@"

ensure_env_file
update_broker_repos_if_requested

echo "Starting NexTrade broker only..."
docker compose --env-file .env -f compose/docker-compose.broker-only.yml up --build ${DETACH}
