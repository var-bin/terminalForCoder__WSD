#!/bin/bash

# create diff for current branch and puts it in the file
# ./fast_diff.sh <branch> - how this script should called

PATH_TO_DIFF_DIR="${HOME}/diff/"
FILE_PREFIX="diff-"
FILE_EXTENTION=".diff"

branch="$1"

# if "$branch" is empty
if [[ -z "$branch" ]]
then
  echo "Enter the branch name"
  exit 0
else
  path="${PATH_TO_DIFF_DIR}${FILE_PREFIX}${branch}${FILE_EXTENTION}"
  git diff origin/master origin/"$branch" > "$path"
fi
