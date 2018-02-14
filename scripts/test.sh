#!/bin/bash

source $(pwd)/scripts/findpackages.sh

# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice updated  into packages folder
for dir in $packages; do
  # go to microservice folder
  cd $dir
  serviceName=$(pwd | sed 's#.*/##')
  echo "[TEST] ${serviceName} microservice"
  # run test
  docker load < $rootDirectory/docker-cache/${serviceName}.tar
  docker run --entrypoint '/bin/sh' ${serviceName} --build -c 'sh tools/config/circleci.test.sh'
  # return to rootDirectory project
  cd $rootDirectory
done
