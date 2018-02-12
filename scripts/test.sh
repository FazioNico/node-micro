# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  echo "[TEST] $(pwd | sed 's#.*/##') microservice"
  # run test
  docker run $(pwd | sed 's#.*/##') -c 'sh tools/config/circleci.test.sh'
  # bash ./tools/config/circleci.test.sh
  # return to rootDirectory project
  cd $rootDirectory
done
