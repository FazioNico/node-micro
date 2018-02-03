FROM node:8.9-alpine
ENV NODE_VERSION 8.9.4
# Create app directory
RUN mkdir -p /usr/todos-service
WORKDIR /usr/todos-service
# install -g node modules
RUN npm install -g typescript webpack
# Copy .npm settings and package.json into container
COPY package.json /usr/todos-service/package.json
# install dependencies
RUN npm install
# move node_modules folder into the right place
RUN mv /usr/todos-service/node_modules /node_modules
# copy source files
COPY . /usr/todos-service
# expose container port
EXPOSE 3001
# build app in production mode ready to deploy
CMD ["npm", "run", "build:server"]
