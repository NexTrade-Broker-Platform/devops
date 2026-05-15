# NexTrade DevOps self-contained setups

Each folder is designed to be copied into an empty workspace root.

Example:

```bash
mkdir NexTrade
cd NexTrade
cp -R /path/to/broker-only/* .
cp /path/to/broker-only/.env.example .env
chmod +x run.sh
./run.sh --update
```

Expected workspace after first run:

```txt
NexTrade/
  docker-compose.yml
  run.sh
  .env
  frontend/
  api-gateway/
  auth-service/
  wallet-service/
  order-service/
  portfolio-service/
  fee-service/
  notification-service/
```

Use `--update` to clone/pull service repositories. Run without `--update` to reuse current local copies.
Use `--foreground` to run Docker Compose without `-d`.
