# make containers
docker compose up -d
docker exec -it spotimedia_app npx prisma migrate deploy
docker exec -it spotimedia_app npm run generate

echo "Docker successfully setup!"

echo "Run scripts/docker-start.sh to start docker (w/o server) or scripts/server.sh to start docker (w/ server)."

echo "Exiting..."
exit