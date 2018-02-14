FROM node:8.9-alpine
ENV NODE_VERSION 8.9.4
# Create app directory
RUN mkdir -p /usr/todos-service/platforms/server
WORKDIR /usr/todos-service
# Copy .npm settings and package.json into container
COPY package.json /usr/todos-service/package.json
# install dependencies
RUN yarn install --production
# move node_modules folder into the right place
RUN mv /usr/todos-service/node_modules /node_modules
# copy source files (or maybe get it from circleci artefact?)
COPY platforms/server /usr/todos-service/platforms/server
# expose container port
EXPOSE 3001
# run app in production mode
CMD ["npm", "run", "start"]
