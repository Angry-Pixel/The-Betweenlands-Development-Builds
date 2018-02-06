#!/bin/bash

export DEPLOY_ENV=true

config="build"
declare -A table
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == "["* ]] && [[ "$line" == *"]:" ]]; then
        if [ ! -z "${section}" ]; then
            table["${section}"]=$(cat entry)
        fi
        >entry
        section=${line:1:${#line}-3}
    else
        line=$(sed 's/\\:/\:/g' <<< $line) #Unescape \: in lines
        echo "${line}" >> entry
    fi
done < "$config"
if [ ! -z ${section} ]; then
    table["${section}"]=$(cat entry)
fi
rm -f entry

#The build number of the build to deploy
export DEPLOY_BUILD_NUMBER=${table['build number']}

#The build type. Can be 'release' or 'development'
export DEPLOY_BUILD_TYPE=${table['type']}

#The title of the github release
export DEPLOY_BUILD_TITLE=${table['title']}

#The body of the github release
export DEPLOY_BUILD_BODY=${table['description']}

#The branch of this build
export DEPLOY_BUILD_BRANCH=${table['branch']}

#The commit of this build
export DEPLOY_BUILD_COMMIT=${table['commit']}

#The directory of the repository to build
export DEPLOY_REPOSITORY_DIR_NAME=Angry-Pixel/The-Betweenlands
export DEPLOY_REPOSITORY_DIR=${TRAVIS_BUILD_DIR}/$DEPLOY_REPOSITORY_DIR_NAME

chmod +x prepare_deploy.sh

git clone --depth=50 --branch=$DEPLOY_BUILD_BRANCH https://github.com/Angry-Pixel/The-Betweenlands.git Angry-Pixel/The-Betweenlands
cd "Angry-Pixel/The-Betweenlands/" || return
git checkout $DEPLOY_BUILD_COMMIT

chmod +x gradlew

export blKeyStore=${TRAVIS_BUILD_DIR}/keystore.jks
echo "$blKeyStore"