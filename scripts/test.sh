# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  echo "[TEST] $(pwd | sed 's#.*/##') microservice"
  # run test
  bash ./tools/config/circleci.test.sh
  # return to rootDirectory project
  cd $rootDirectory
done
