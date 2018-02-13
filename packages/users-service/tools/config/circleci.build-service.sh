#!/usr/bin/env bash

yarn install --silent --non-interactive --no-lockfile
# build production
yarn run webpack:prod
# copy dist/ folder to .workflows cache directory
serviceName=$(pwd | sed 's#.*/##')
echo '--------------'
find ./platforms/server
echo '--------------'
mkdir -p ~/repo/docker-cache/${serviceName}/platforms/server
cp -rf ./platforms/server ~repo/docker-cache/${serviceName}/platforms/server
