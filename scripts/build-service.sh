# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
# for dir in $(ls -d  packages/*); do
  # go to microservice folder
  # cd $dir
  cd packages/users-service
  serviceName=$(pwd | sed 's#.*/##')
  echo "[BUILD SERVICE] ${serviceName} microservice"
  # run test
  docker load < $rootDirectory/docker-cache/${serviceName}.tar
  docker run ${serviceName} sh -c './tools/config/circleci.build-service.sh'

  # return to rootDirectory project
  cd $rootDirectory
# done
