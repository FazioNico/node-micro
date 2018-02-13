#!/usr/bin/env bash

yarn install --silent --non-interactive --no-lockfile
# build production
yarn run build:server
# copy dist/ folder to .workflows cache directory
serviceName=$(pwd | sed 's#.*/##')
mkdir -p ~/repo/docker-cache/${serviceName}/platforms/server
cp -r ./platforms/server ~repo/docker-cache/${serviceName}/platforms/server
