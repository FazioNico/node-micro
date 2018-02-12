# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  serviceName=$(pwd | sed 's#.*/##')
  echo "[TEST] ${serviceName} microservice"
  # run test
  # docker load < docker-cache/${serviceName}.tar
  docker run ${serviceName} -c 'sh tools/config/circleci.test.sh'
  # bash ./tools/config/circleci.test.sh
  # return to rootDirectory project
  cd $rootDirectory
done
