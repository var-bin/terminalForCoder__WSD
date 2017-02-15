#!/bin/bash

# up_repo.sh - check repositories in core/vendor
# find all directories that included .git
# If any repo hasn't switched on master branch
# than git checkout master && git branch && git pull
# else git branch && git pull

# get list of repositories
findRepo() {
  REPO_NAME="terminalForCoder__WSD"
  PATH_TO_VENDORS_REPO="${HOME}/${REPO_NAME}/bash/core/vendors/"

  # find all git repositories in $PATH_TO_VENDORS_REPO
  # filter by /.git

  if [[ -e "$PATH_TO_VENDORS_REPO" ]]
  then
    r=$( find "$PATH_TO_VENDORS_REPO" -name .git | xargs | sed "s/\\/.git//g" )
  else
    echo "Cannot find ${PATH_TO_VENDORS_REPO}"
    echo "Try to edit REPO_NAME in ${0}"
    exit 0
  fi

  # do check repositories stuff
  checkBranch $r
}

# do check repositories stuff
checkBranch() {
  BRANCH="master"
  CHECK_BRANCH="* master"

  # $i is an item in $r
  for i in "$@"
  do
    # get current branch name
    b=$(cd "$i" && git branch | grep \*)
    echo "repo: ${i}"
    echo "current brunch: ${b}"

    # check branch
    if [[ "$b" != "$CHECK_BRANCH" ]]
    then
      echo "!Error! ${i} is not on ${BRANCH} branch"
      echo "Current branch is ${b}"
      echo "Checkout to ${BRANCH} and do git pull stuff for ${i}"
      cd "$i" && git checkout "$BRANCH" && git branch && git pull origin "$BRANCH"
      echo ""
    else
      echo "Do git pull stuff for ${i}"
      cd "$i" && git branch && git pull origin "$BRANCH"
      echo ""
    fi
  done
  echo "Done. Congratulation, you win!"
}

findRepo "$@"
