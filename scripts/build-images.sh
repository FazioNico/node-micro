# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
# for dir in $(ls -d  packages/*); do
  # go to microservice folder
  # cd $dir
  cd packages/users-service
  serviceName=$(pwd | sed 's#.*/##')
  # build image
  if [ -f ./tools/config/circleci.build-images.sh ]; then
    echo "[BUILD-IMAGES] ${serviceName} microservice"
    # bash ./tools/config/circleci.build-images.sh
    # tag image
    TAG=0.1.$CIRCLE_BUILD_NUM
    # build docker image
    docker build -t registry.agenda.ch/fazio/$serviceName:$TAG  .
    # login to docker hub
    docker login registry.agenda.ch -u $USER_DOCKER -p $PASS_DOCKER
    echo "[DEPLOY-IMAGES] ${serviceName} microservice"
    # push docker image
    docker push registry.agenda.ch/fazio/$serviceName:$TAG
  fi
  # return to rootDirectory project
  cd $rootDirectory
# done
