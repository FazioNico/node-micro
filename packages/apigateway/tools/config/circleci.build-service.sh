#!/usr/bin/env bash

yarn install --production --silent --non-interactive --no-lockfile
# build production
yarn run webpack:prod
# copy dist/ folder to .workflows cache directory
serviceName=$(pwd | sed 's#.*/##')
cp -r ./platforms/server ~repo/${serviceName}/platforms/server
