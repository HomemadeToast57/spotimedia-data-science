## Steps to test the application
1. Make sure you have Docker Desktop installed (https://www.docker.com/get-started/)
2. Open Docker Desktop and follow the instructions
3. Create a file called `.env` and copy the contents from `.env.example` to this new file
4. Run `scripts/docker-setup.sh` from the root folder of this repo to setup the Docker container
5. Run `scripts/server.sh` to start the server!
    - Go to [http:localhost:1234/](http:localhost:1234/) to make a request to the server
    - Go to [http:localhost:5555/](http:localhost:5555/) to view the Postgres database

#### Let me know if you have any questions! 🙏
