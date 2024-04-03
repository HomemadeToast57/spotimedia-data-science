# give selection between docker containers to shell into by reading docker ps
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
echo "Enter the container name or id to shell into (default=spotimedia_app):"

read -r container_name

# if the user did not enter a container name or id, default to app
if [ -z "$container_name" ]
then
  container_name="spotimedia_app"
fi

# shell into the container
docker exec -it "$container_name" bash
