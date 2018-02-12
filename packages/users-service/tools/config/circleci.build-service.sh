#!/usr/bin/env bash

yarn install --silent --non-interactive --no-lockfile
# build production
yarn run webpack:prod
# copy dist/ folder to .workflows cache directory
serviceName=$(pwd | sed 's#.*/##')
mkdir -p ~/repo/docker-cache/${serviceName}/platforms/server
cp ./platforms/server/index.js ~repo/docker-cache/${serviceName}/platforms/server/index.js
