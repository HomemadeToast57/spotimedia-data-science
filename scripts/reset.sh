#!/bin/bash

# ask for confirmation to delete all docker containers and images
read -p "Are you sure you want to delete all docker containers and images? (y/n) " -n 1 -r
echo

# if the user confirms, delete all docker containers and images in the current directory
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Deleting all docker containers and images..."
  docker-compose down --rmi all
  echo "All docker containers and images deleted!"
fi
