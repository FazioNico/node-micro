#!/bin/bash

latestRef=$(git rev-parse HEAD^)
latestCmt=$(git log origin/master -1 --format="%H")
echo "latestRef-> ${latestRef}"
echo "latestCmt-> ${latestCmt}"
packages=$(git diff --name-only ${latestRef} ${latestCmt} -- packages  | awk '{ split($0,a,/\//); print a[1]"/"a[2] }' | uniq )


# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice updated  into packages folder
for dir in $packages; do
  # go to microservice folder
  cd $dir
  serviceName=$(pwd | sed 's#.*/##')
  echo "[BUILD SERVICE] ${serviceName} microservice"
  # run dev image to build service as prod
  docker load < $rootDirectory/docker-cache/${serviceName}.tar
  # docker run ${serviceName} sh -c './tools/config/circleci.build-service.sh'
  docker run -v $(pwd):/usr/${serviceName}  --entrypoint '/bin/sh' ${serviceName} -c 'sh tools/config/circleci.build-service.sh'

  # Create Docker Production Images
  # tag image
  TAG=0.1.$CIRCLE_BUILD_NUM
  # build docker image
  echo "[BUILD-IMAGES-PROD] ${serviceName} microservice"
  docker build -t registry.agenda.ch/fazio/$serviceName:$TAG  .
  # login to docker hub
  docker login registry.agenda.ch -u ${USER_DOCKER} -p ${PASS_DOCKER}
  # push docker image
  echo "[PUSH-IMAGES] ${serviceName} microservice"
  docker push registry.agenda.ch/fazio/$serviceName:$TAG
  # return to rootDirectory project
  cd $rootDirectory
done
