# defin project rootDirectory
rootDirectory=$(pwd)
# do loop for each microservice found into packages folder
for dir in $(ls -d  packages/*); do
  # go to microservice folder
  cd $dir
  # run test if define with npm
  if [ -f package.json ]; then
    echo "[TEST] $(pwd | sed 's#.*/##') microservice: starting test..."
    npm install
    npm run test
  fi
  # run test if define with otherlang
  if [ -f package.otherlang ]; then
    run test
  fi
  # return to rootDirectory project
  cd $rootDirectory
done
