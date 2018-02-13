#!/usr/bin/env bash

yarn install --silent --non-interactive --no-lockfile
# build production
yarn run webpack:prod
# copy dist/ folder to .workflows cache directory
# serviceName=$(pwd | sed 's#.*/##')
# mkdir -p ~/repo/docker-cache
# tar -cvf ~/repo/docker-cache/${serviceName}-build.tar ./platforms/
servicename=$(pwd | sed 's#.*/##');
# tag image
TAG=0.1.$CIRCLE_BUILD_NUM
# build docker image
docker build -t registry.agenda.ch/fazio/$servicename:$TAG  .
# login to docker hub
docker login registry.agenda.ch -u $USER_DOCKER -p $PASS_DOCKER
# push docker image
docker push registry.agenda.ch/fazio/$servicename:$TAG
