#!/bin/bash

# Sets up the necessary environment variables

echo "BS_DEPLOY_REPOSITORY_URI=git@github.com:Angry-Pixel/The-Betweenlands-Development-Builds.git" >> $GITHUB_ENV
echo "BS_DEPLOY_REPOSITORY_BRANCH=master" >> $GITHUB_ENV
echo "BS_DEPLOY_NAME=Build Wizard" >> $GITHUB_ENV
echo "BS_ABORT_ON_DEPLOY_ERROR=true" >> $GITHUB_ENV

if [ "$BS_IS_DEPLOYMENT" == 'false' ]; then
  echo "BS_BUILD_NOTES_FILE=build_notes" >> $GITHUB_ENV
  
  if [[ "$GITHUB_REF" == *"release"* ]]; then
    echo "BS_BUILD_TYPE=release" >> $GITHUB_ENV
    echo "BS_BUILD_RELEASE=true" >> $GITHUB_ENV
    echo "BS_BUILD_TITLE=Release Build ${GITHUB_REF##*/}-${GITHUB_RUN_NUMBER}" >> $GITHUB_ENV
    echo "BS_BUILD_TAG=release-${BS_BUILD_BRANCH}-${BS_BUILD_NUMBER}-$(date +'%d.%m.%Y')" >> $GITHUB_ENV

    echo "Creating release notes"
    #Get previous release tag and then list commits since that release as release notes
    git fetch --all --tags -f
    previous_release_tag=$(git describe $(git for-each-ref --sort=-taggerdate --format '%(objectname)' refs/tags) --tags --abbrev=0 --match *-release | sed -n 2p)
    echo "Creating list of changes since ${previous_release_tag}..."
	echo "Commit: <a href="\""${BS_BUILD_URL}/commit/${GITHUB_SHA}"\"">${BS_BUILD_URL}/commit/${GITHUB_SHA}</a>" >> build_notes
    echo "<details><summary>Changes</summary><ul>" >> build_notes
	echo "Fetching commits"
	git fetch --shallow-since=$(git log -1 --format=%ct ${previous_release_tag})
    git log --since="$(git log -1 --format=%ai ${previous_release_tag})" --pretty=format:'<li>%n%an, %ad:%n<pre>%B</pre></li>' --no-merges >> build_notes
    echo "</ul></details>" >> build_notes
    cat build_notes
  else
    echo "BS_BUILD_TYPE=development" >> $GITHUB_ENV
    echo "BS_BUILD_RELEASE=false" >> $GITHUB_ENV
    echo "BS_BUILD_TITLE=Development Build ${GITHUB_REF##*/}-${GITHUB_RUN_NUMBER}" >> $GITHUB_ENV
    echo "BS_BUILD_TAG=dev-${BS_BUILD_BRANCH}-${BS_BUILD_NUMBER}-$(date +'%d.%m.%Y')" >> $GITHUB_ENV

    echo "Creating build notes"
    #Use latest commit message as release note
	echo "Commit: <a href="\""${BS_BUILD_URL}/commit/${GITHUB_SHA}"\"">${BS_BUILD_URL}/commit/${GITHUB_SHA}</a>" >> build_notes
    git log -1 --pretty=format:'%an, %ad:%n<pre>%B</pre>' >> build_notes
  fi
fi

if [ "$BS_PULL_REQUEST" == 'false' ]; then
  echo "DEPLOY_ENV=true" >> $GITHUB_ENV
  echo "DEPLOY_BUILD_TYPE=${BS_BUILD_TYPE}" >> $GITHUB_ENV
  echo "DEPLOY_BUILD_NUMBER=${BS_BUILD_NUMBER}" >> $GITHUB_ENV
fi