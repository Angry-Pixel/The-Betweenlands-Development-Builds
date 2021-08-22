#!/bin/bash

echo "Running build"

if [ "$BS_IS_DEPLOYMENT" == 'true' ]; then
  
  git clone --depth=10 --branch="$BUILD_BRANCH" "${BUILD_URL}.git" repository
  cd repository || return 1
  
  git checkout "$BUILD_COMMIT"
  
  chmod +x "../.github/workflows/${GITHUB_WORKFLOW}/config/build.sh"
  source "../.github/workflows/${GITHUB_WORKFLOW}/config/build.sh"
  
  cd -
  
else

  chmod +x "./.github/workflows/${GITHUB_WORKFLOW}/config/build.sh"
  source "./.github/workflows/${GITHUB_WORKFLOW}/config/build.sh"
  
fi