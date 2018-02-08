# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  echo "[INSTALL] $(pwd | sed 's#.*/##') microservice: packages dependencies"
  # install project dependencies
  npm install
  # return to rootDirectory project
  cd $rootDirectory
done
