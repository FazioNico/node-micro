# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
# for dir in $(ls -d  packages/*); do
  # go to microservice folder
  # cd $dir
  cd packages/users-service
  serviceName=$(pwd | sed 's#.*/##')
  echo "[TEST] ${serviceName} microservice"
  # run test
  docker load < ~/repo/docker-cache/${serviceName}.tar
  docker run --entrypoint '/bin/sh' ${serviceName} -c 'sh tools/config/circleci.test.sh'
  # bash ./tools/config/circleci.test.sh
  # return to rootDirectory project
  cd $rootDirectory
# done
