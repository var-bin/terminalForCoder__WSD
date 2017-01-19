#!/bin/bash

# up_repo.sh - check repositories in core/vendor
# find all directories that included .git
# If any repo hasn't switched on master branch
# than git checkout master && git branch && git pull
# else git branch && git pull

# get list of repositories
findRepo() {
  REPO_NAME="terminalForCoder__WSD"
  PATH_TO_VENDOR_REPO="${HOME}/${REPO_NAME}/bash/core/vendors/"

  # find all git repositories in $PATH_TO_VENDOR_REPO
  # filter by /.git

  if [[ -e "$PATH_TO_VENDOR_REPO" ]]
  then
    r=$( find "$PATH_TO_VENDOR_REPO" -name .git | xargs | sed "s/\\/.git//g" )
  else
    echo "Can not find ${PATH_TO_VENDOR_REPO}"
    echo "Try to edit REPO_NAME"
    exit 0
  fi

  # do check repositories stuff
  checkBranch $r
}

# do check repositories stuff
checkBranch() {
  BRANCH="master"

  # $i is an item in $r
  for i in "$@"
  do
    # get current branch name
    b=$(cd "$i" && git branch | grep \*)
    echo "repo: ${i}"
    echo "current brunch: ${b}"

    # check branch
    if [[ "$b" != "* master" ]]
    then
      echo "!Error! ${i} is not on ${BRANCH} branch"
      echo "Current branch is ${b}"
      cd "$i" && git checkout "$BRANCH" && git branch && git pull origin "$BRANCH"
    else
      echo "Do pull stuff"
      cd "$i" && git branch && git pull origin "$BRANCH"
      echo ""
    fi
  done
  echo "Done. Congratulation, you win!"
}

findRepo "$@"
