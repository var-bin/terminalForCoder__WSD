#!/bin/bash

# create diff for current branch and puts it in the file

PATH_TO_DIFF_DIR="$HOME/diff/"
FILE_PREFIX="diff-"
FILE_EXTENTION=".diff"

branch=$1

if [[ -z $branch ]]
then
  echo "Enter the branch name"
else
  path="$PATH_TO_DIFF_DIR$FILE_PREFIX$branch$FILE_EXTENTION"
  git diff origin/master origin/"$branch" > "$path"
fi