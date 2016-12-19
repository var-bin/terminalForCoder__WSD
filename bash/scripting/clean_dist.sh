#!/bin/bash

# clean_dist.sh - clean dist for current theme


cleanDist() {
  theme=$1
  NAME="_dist"

  path_to_assets="$HOME/terminalForCoder__WSD/bash/core/assets"

  # if $1 == "" clean all _dist in each theme
  if [[ -z $theme ]]
  then
    theme="assets"
    path_to_dist="$path_to_assets/"
  else
    path_to_dist="$path_to_assets/$theme"
  fi

  if [[ -n $(find $path_to_dist -type d -name $NAME) ]]
  then
    # do clear stuff
    find $path_to_dist -type d -name $NAME | xargs -l rm -rfv
    echo "Dist of $theme have already deleted: $path_to_dist"
  else
    echo "Can not find $NAME in $theme"
  fi
}

cleanDist $@
