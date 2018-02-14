#!/bin/bash

source $(pwd)/scripts/findpackages.sh
# echo  $packages | sed 's#.*/##'

# defin project rootDirectory
rootDirectory=$(pwd)
# create docker-cache Workspace Directory
mkdir docker-cache
# do loop for each microservice updated  into packages folder
for dir in $packages; do
  # go to microservice folder
  cd $dir
  echo $(pwd)
  serviceName=$(pwd | sed 's#.*/##')
  echo "[INSTALL] ${serviceName} microservice: packages dependencies"
  # install project dependencies
  docker build -f Dockerfile.dev -t ${serviceName} .
  # save image to docker cache
  echo "[SAVE DEV IMAGE] ${serviceName} microservice"
  docker save -o $rootDirectory/docker-cache/${serviceName}.tar ${serviceName}
  # return to rootDirectory project

  cd $rootDirectory
done

echo '----------------------------------------------------'
echo '----------------------------------------------------'
echo '[SUCCESS] Project dependencies install with success!'
