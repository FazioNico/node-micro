# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  # build image
  if [ -f ./tools/config/circleci.build-images.sh ]; then
    echo "[BUILD-IMAGES] $(pwd | sed 's#.*/##') microservice"
    bash ./tools/config/circleci.build-images.sh
  fi
  # return to rootDirectory project
  cd $rootDirectory
done
