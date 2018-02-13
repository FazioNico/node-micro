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

  export VAR1=value1
  export VAR2=value2
  # docker run ${serviceName} sh -c './tools/config/circleci.build-service.sh'
  docker run -v $(pwd):/usr/${serviceName}  --entrypoint '/bin/sh' ${serviceName} -c 'sh tools/config/circleci.build-service.sh'


  # tag image
  TAG=0.1.$CIRCLE_BUILD_NUM
  # build docker image
  docker build -t registry.agenda.ch/fazio/$serviceName:$TAG  .
  # login to docker hub
  docker login registry.agenda.ch -u fazio -p Agenda.ch2018
  # push docker image
  docker push registry.agenda.ch/fazio/$serviceName:$TAG
  # return to rootDirectory project
  cd $rootDirectory
# done
