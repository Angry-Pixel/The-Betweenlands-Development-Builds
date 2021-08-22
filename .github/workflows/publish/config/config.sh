#!/bin/bash

# Sets up the necessary environment variables

# Required

echo "BS_DEPLOY_REPOSITORY_URI=git@github.com:Angry-Pixel/The-Betweenlands-Development-Builds.git" >> $GITHUB_ENV
echo "BS_DEPLOY_REPOSITORY_BRANCH=master" >> $GITHUB_ENV
echo "BS_DEPLOY_NAME=Build Wizard" >> $GITHUB_ENV
echo "BS_ABORT_ON_DEPLOY_ERROR=true" >> $GITHUB_ENV
echo "BS_BUILD_TYPE=release" >> $GITHUB_ENV
echo "BS_BUILD_RELEASE=true" >> $GITHUB_ENV
echo "BS_BUILD_TITLE=Release Build ${GITHUB_REF##*/}-${GITHUB_RUN_NUMBER}" >> $GITHUB_ENV
echo "BS_BUILD_TAG=release-${BS_BUILD_BRANCH}-${BS_BUILD_NUMBER}-$(date +'%d.%m.%Y')" >> $GITHUB_ENV
echo "BS_BUILD_NOTES_FILE=release_notes" >> $GITHUB_ENV

# Optional

if [ "$BS_PULL_REQUEST" == 'false' ]; then
  echo "DEPLOY_ENV=true" >> $GITHUB_ENV
  echo "DEPLOY_BUILD_TYPE=release" >> $GITHUB_ENV
  echo "DEPLOY_BUILD_NUMBER=$GITHUB_RUN_NUMBER" >> $GITHUB_ENV
fi

if [ "$BS_IS_DEPLOYMENT" == 'false' ]; then
  echo "Creating release notes"
  git fetch --all --tags
  previous_release_tag=$(git describe $(git rev-list --tags --max-count=1)^ --tags --abbrev=0 --match *-release)
  echo "Creating list of changes since ${previous_release_tag}..."
  echo "<details><summary>Changes</summary>" >> release_notes
  git log ${previous_release_tag}..HEAD --since="$(git log -1 --format=%ai ${previous_release_tag})" --pretty=format:'%an, %ar (%ad):%n%B' --no-merges >> release_notes
  echo "</details>" >> release_notes
  cat release_notes
fi