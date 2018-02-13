# defin project rootDirectory
rootDirectory=$(pwd)
mkdir -p ~/repo/docker-cache
# do loop for each microservice found into packages folder
#for dir in $(ls -d  packages/*); do
  # go to microservice folder
  # cd $dir
  cd packages/users-service
  serviceName=$(pwd | sed 's#.*/##')

  echo "[INSTALL] ${serviceName} microservice: packages dependencies"
  # install project dependencies
  docker build -f Dockerfile.dev -t ${serviceName} .

  docker save -o ~/repo/docker-cache/${serviceName}.tar ${serviceName}

  # bash ./tools/config/circleci.install.sh
  # return to rootDirectory project
  cd $rootDirectory
# done

echo '----------------------------------------------------'
echo '----------------------------------------------------'
echo '[SUCCESS] Project dependencies install with success!'
