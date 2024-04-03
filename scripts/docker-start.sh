# docker compose up

echo "Booting up docker compose..."
docker-compose up -d

# sleep until CTRL-C
# wait till the user presses CTRL-C
trap "echo \"\nStopping docker compose...\"; docker-compose stop; echo \"Docker compose stopped!\"; exit" INT


echo "Docker is up and running!"
while :; do sleep 2073600; done