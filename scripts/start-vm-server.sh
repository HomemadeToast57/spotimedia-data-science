#!/bin/bash

docker compose up -d
echo "Docker is up and running!"

docker exec -it spotimedia_app npm install -y
docker exec -it spotimedia_app npx prisma migrate status
docker exec -it spotimedia_app npx prisma migrate deploy

docker exec -t spotimedia_app npx --yes localtunnel --port 1234 --subdomain "cs415-spotimedia-1234" &
docker exec -t spotimedia_app npx --yes localtunnel --port 5555 --subdomain "cs415-spotimedia-5555" &
docker exec -t spotimedia_app npx --yes localtunnel --port 8081 --subdomain "cs415-spotimedia-8081" &

sleep 5

docker exec -it spotimedia_app npm run generate
docker exec -d spotimedia_app npm run start