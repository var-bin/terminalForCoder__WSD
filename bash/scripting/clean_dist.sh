#!/bin/bash

# clean_dist.sh - clean dist for current theme
# ./clean_dist.sh - clean all directories with dists
# ./clean_dist.sh <theme> - clean <theme> dist


cleanDist() {
  theme="$1"
  DIST_NAME="_dist"
  REPO_NAME="terminalForCoder__WSD"
  PATH_TO_CORE="${HOME}/${REPO_NAME}/bash/core"

  PATH_TO_ASSETS="${PATH_TO_CORE}/assets"

  # if "${PATH_TO_CORE}" is not exist
  # show info message
  if [[ ! -e "${PATH_TO_CORE}" ]]
  then
    echo "Cannot find ${PATH_TO_CORE}"
    echo "Try to edit REPO_NAME in ${0}"
    exit 0
  fi

  # if $1 == "" clean all _dist in each theme
  if [[ -z "$theme" ]]
  then
    path_to_dist="$PATH_TO_ASSETS"
  else
    path_to_dist="${PATH_TO_ASSETS}/${theme}"
  fi

  if [[ -n $(find "$path_to_dist" -type d -name "$DIST_NAME") ]]
  then
    # do clean stuff
    find "$path_to_dist" -type d -name "$DIST_NAME" | xargs rm -rfv
    echo "Dist of ${theme} has already deleted: ${path_to_dist}"
  else
    echo "Cannot find ${DIST_NAME} in ${theme}"
  fi
}

cleanDist "$@"
