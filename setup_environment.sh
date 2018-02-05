export DEPLOY_ENV=true

#The build number of the build to deploy
export DEPLOY_BUILD_NUMBER=$(jq -r '.build_number' build.json)

#The build type. Can be 'release' or 'development'
export DEPLOY_BUILD_TYPE=$(jq -r '.type' build.json)

#The title of the github release
export DEPLOY_BUILD_TITLE=$(jq -r '.title' build.json)

#The body of the github release
export DEPLOY_BUILD_BODY=$(jq -r '.description' build.json)

#The branch of this build
export DEPLOY_BUILD_BRANCH=$(jq -r '.branch' build.json)

#The commit of this build
export DEPLOY_BUILD_COMMIT=$(jq -r '.commit' build.json)

#The directory of the repository to build
export DEPLOY_REPOSITORY_DIR_NAME=Angry-Pixel/The-Betweenlands/
export DEPLOY_REPOSITORY_DIR=${TRAVIS_BUILD_DIR}/$DEPLOY_REPOSITORY_DIR_NAME

chmod +x prepare_deploy.sh

git clone --depth=50 --branch=$DEPLOY_BUILD_BRANCH https://github.com/Angry-Pixel/The-Betweenlands.git Angry-Pixel/The-Betweenlands
cd "Angry-Pixel/The-Betweenlands/"
git checkout $DEPLOY_BUILD_COMMIT

chmod +x gradlew

export blKeyStore=${DEPLOY_REPOSITORY_DIR}/keystore.jks
echo "$blKeyStore"