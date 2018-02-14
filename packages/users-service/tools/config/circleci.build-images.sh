#!/usr/bin/env bash

# get service name
servicename=$(pwd | sed 's#.*/##');
# tag image
TAG=0.1.$CIRCLE_BUILD_NUM
# build docker image
docker build -t registry.agenda.ch/fazio/$servicename:$TAG  .
# login to docker hub
docker login registry.agenda.ch -u $USER_DOCKER -p $PASS_DOCKER
# push docker image
docker push registry.agenda.ch/fazio/$servicename:$TAG
#
