FROM node:8.9-alpine
ENV NODE_VERSION 8.9.4
# Create app directory
RUN mkdir -p /usr/apigateway/platforms/server
WORKDIR /usr/apigateway
# Copy .npm settings and package.json into container
COPY package.json /usr/apigateway/package.json
# install dependencies
RUN yarn install --production
# move node_modules folder into the right place
RUN mv /usr/apigateway/node_modules /node_modules
# copy source files (or maybe get it from circleci artefact?)
COPY ~repo/docker-cache/apigateway/platforms/server /usr/apigateway/platforms/server
# expose container port
EXPOSE 3000
# run app in production mode
CMD ["npm", "run", "start"]
