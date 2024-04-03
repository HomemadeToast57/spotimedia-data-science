FROM node:lts

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]


RUN npm install -y
RUN npm install -g nodemon
RUN npm install -g typescript
RUN npm install -g ts-node

COPY . .