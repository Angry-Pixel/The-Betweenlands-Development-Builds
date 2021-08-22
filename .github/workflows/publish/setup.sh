#!/bin/bash

# Sets up the deployment environment variables

echo "Running setup"

if [ -f "build_config" ]; then
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
  done < "build_config"
  if [ ! -z ${section} ]; then
    table["${section}"]=$(cat entry)
  fi
  rm entry

  echo "BS_BUILD_NUMBER=${table['number']}" >> $GITHUB_ENV
  export BS_BUILD_NUMBER=${table['number']}

  echo "BS_BUILD_TYPE=${table['type']}" >> $GITHUB_ENV
  export BS_BUILD_TYPE=${table['type']}

  echo "BS_BUILD_TITLE=${table['title']}" >> $GITHUB_ENV
  export BS_BUILD_TITLE=${table['title']}

  echo "BS_BUILD_URL=${table['url']}" >> $GITHUB_ENV
  export BS_BUILD_URL=${table['url']}

  echo "BS_BUILD_BRANCH=${table['branch']}" >> $GITHUB_ENV
  export BS_BUILD_BRANCH=${table['branch']}

  echo "BS_BUILD_COMMIT=${table['commit']}" >> $GITHUB_ENV
  export BS_BUILD_COMMIT=${table['commit']}

  echo 'BS_BUILD_NOTES<<EOF' >> $GITHUB_ENV
  cat build_notes >> $GITHUB_ENV
  echo 'EOF' >> $GITHUB_ENV
  export BS_BUILD_NOTES=$(cat build_notes)
else
  if [ "$BS_IS_DEPLOYMENT" = "true" ]; then
    echo "Could not find build config"
    return 1
  fi
fi

chmod +x "./.github/workflows/${GITHUB_WORKFLOW}/config/config.sh"
source "./.github/workflows/${GITHUB_WORKFLOW}/config/config.sh"

if [ "$BS_BUILD_RELEASE" = "true" ]; then
  echo "BS_BUILD_PRERELEASE=false" >> $GITHUB_ENV
else
  echo "BS_BUILD_PRERELEASE=true" >> $GITHUB_ENV
fi