#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh "$@"

ensure_env_file
update_broker_repos_if_requested

echo "Starting NexTrade broker connected to deployed stock exchange..."
echo "Make sure .env contains deployed EXCHANGE_REST_URL and EXCHANGE_WS_URI."
docker compose --env-file .env -f compose/docker-compose.broker-deployed-exchange.yml up --build ${DETACH}
