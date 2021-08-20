FROM node:14

WORKDIR /var/app/

COPY ../app/package*.json ./
COPY ../app/tsconfig*.json ./

RUN npm config set strict-ssl false
RUN npm install -g typescript
RUN npm i ts-node-dev -g
RUN npm i