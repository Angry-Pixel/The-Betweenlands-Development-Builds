git config --local user.name "Travis Build Wizard"
git config --local user.email "<>"
if [ "$DEPLOY_BUILD_TYPE" == "release" ]; then
  git tag "release-${DEPLOY_BUILD_NUMBER}-$(date +'%d.%m.%Y')"
else
  git tag "dev-${DEPLOY_BUILD_NUMBER}-$(date +'%d.%m.%Y')"
fi