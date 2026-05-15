# NexTrade DevOps

This repository orchestrates the NexTrade broker platform in three modes:

1. Broker only
2. Broker + local stock exchange
3. Broker + deployed stock exchange

## First setup

```bash
cp env/.env.example .env
```

Edit `.env` and set secrets/API credentials.

## Run broker only

```bash
./scripts/run-broker-only.sh --update
```

## Run broker + local stock exchange

```bash
./scripts/run-broker-local-exchange.sh --update
```

This starts the local stock exchange compose first if `stock-exchange/docker-compose.yml` exists, then starts broker services attached to the exchange Docker network.

## Run broker + deployed stock exchange

Set these in `.env`:

```env
EXCHANGE_REST_URL=https://your-exchange-host/api/v1
EXCHANGE_WS_URI=wss://your-exchange-host/ws
EXCHANGE_API_KEY=...
EXCHANGE_API_SECRET=...
```

Then run:

```bash
./scripts/run-broker-deployed-exchange.sh --update
```

## Useful commands

```bash
docker compose -f compose/docker-compose.broker-only.yml down

docker compose -f compose/docker-compose.broker-only.yml down -v

docker compose -f compose/docker-compose.broker-only.yml logs -f
```

Do not commit `.env`.
