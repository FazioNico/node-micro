# defin project rootDirectory
rootDirectory=$(pwd)
mkdir -p ~/repo/docker-cache
# do loop for each microservice found into packages folder
# for dir in $(ls -d  packages/*); do
  # go to microservice folder
  # cd $dir
  cd packages/users-service
  serviceName=$(pwd | sed 's#.*/##')
  echo "[BUILD SERVICE] ${serviceName} microservice"
  # run test
  docker load < ~/repo/docker-cache/${serviceName}.tar
  docker run -v ~repo:/usr/${serviceName} --entrypoint '/bin/sh' ${serviceName} -c 'sh tools/config/circleci.build-service.sh'

  # return to rootDirectory project
  cd $rootDirectory
# done
