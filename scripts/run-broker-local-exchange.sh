#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh "$@"

STOCK_EXCHANGE_ORG="${STOCK_EXCHANGE_ORG:-Lynx-Stock-Exchange}"
STOCK_EXCHANGE_REPO="${STOCK_EXCHANGE_REPO:-stock-exchange}"
STOCK_EXCHANGE_BRANCH="${STOCK_EXCHANGE_BRANCH:-main}"
STOCK_EXCHANGE_DIR="${STOCK_EXCHANGE_DIR:-stock-exchange}"
STOCK_EXCHANGE_BASE_URL="${STOCK_EXCHANGE_BASE_URL:-https://github.com/${STOCK_EXCHANGE_ORG}}"

ensure_env_file
update_broker_repos_if_requested

if [ "${UPDATE}" = true ]; then
  exchange_url="${STOCK_EXCHANGE_BASE_URL}/${STOCK_EXCHANGE_REPO}.git"
  if [ -d "${STOCK_EXCHANGE_DIR}/.git" ]; then
    echo "Pulling local stock exchange from ${STOCK_EXCHANGE_BRANCH}..."
    git -C "${STOCK_EXCHANGE_DIR}" fetch origin
    git -C "${STOCK_EXCHANGE_DIR}" checkout "${STOCK_EXCHANGE_BRANCH}"
    git -C "${STOCK_EXCHANGE_DIR}" pull origin "${STOCK_EXCHANGE_BRANCH}"
  else
    echo "Cloning local stock exchange into ${STOCK_EXCHANGE_DIR}..."
    git clone --branch "${STOCK_EXCHANGE_BRANCH}" "${exchange_url}" "${STOCK_EXCHANGE_DIR}"
  fi
fi

if [ -f "${STOCK_EXCHANGE_DIR}/docker-compose.yml" ]; then
  echo "Starting local stock exchange first..."
  docker compose -f "${STOCK_EXCHANGE_DIR}/docker-compose.yml" up --build -d
else
  echo "WARNING: ${STOCK_EXCHANGE_DIR}/docker-compose.yml not found."
  echo "The broker will still start, but the external exchange network must already exist."
fi

echo "Starting NexTrade broker connected to local stock exchange..."
docker compose --env-file .env -f compose/docker-compose.broker-local-exchange.yml up --build ${DETACH}
