#!/bin/bash


# call npm run start from outside the container
docker compose up -d
echo "Docker is up and running!"

# Array of port numbers and titles
# ports=(1234:express 5555:prisma_studio 8080:redis_commander)


# Loop through each port number and create a tunnel
# for port in "${ports[@]}"
# do
#     # Split the port and title using the colon separator
#     IFS=: read -r port title <<< "$port"
    
#     # Create the tunnel with the specified subdomain and title
#     url=$(docker exec spotimedia_app npx localtunnel --port "$port" --subdomain "cs415-spotimedia-$port")
    
#     # Print the port, title, and URL
#     echo "Port: $port"
#     echo "Title: $title"
#     echo "URL: $url"
#     echo "------------------------"
# done

# check for unapplied migrations prisma
docker exec -it spotimedia_app npm install -y
docker exec -it spotimedia_app npx prisma migrate status
docker exec -it spotimedia_app npx prisma migrate deploy

docker exec -t spotimedia_app npx --yes localtunnel --port 1234 --subdomain "cs415-spotimedia-1234" &
docker exec -t spotimedia_app npx --yes localtunnel --port 5555 --subdomain "cs415-spotimedia-5555" &
docker exec -t spotimedia_app npx --yes localtunnel --port 6379 --subdomain "cs415-spotimedia-6379" &
docker exec -t spotimedia_app npx --yes localtunnel --port 8081 --subdomain "cs415-spotimedia-8081" &

sleep 5

docker exec -it spotimedia_app npm run generate
docker exec -it spotimedia_app npm run start


trap "docker compose stop" EXIT