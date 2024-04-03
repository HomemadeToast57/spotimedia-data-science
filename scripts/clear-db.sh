#!/bin/bash

# Ask for confirmation before executing the command to reset the database using Prisma
read -p "Are you sure you want to reset the database? This action cannot be undone. (y/n) " answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    # Execute the command to reset the database using Prisma
    docker exec -it spotimedia_app npx prisma migrate reset
else
    echo "Database reset cancelled."
fi