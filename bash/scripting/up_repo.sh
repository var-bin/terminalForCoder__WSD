#!/bin/bash

# up_repo.sh - check repositories in core/vendor
# find all directories that included .git
# If any repo hasn't switched on master branch
# than git checkout master && git branch && git pull
# else git branch && git pull

# get list of repositories
findRepo() {
  path_to_vendor_repo="/d/var-bin/terminalForCoder__WSD/bash/core/vendors/"
  # find all git repositories in $path_to_vendor_repo
  # filter by /.git
  r=$(find $path_to_vendor_repo -name .git | xargs | sed "s/\\/.git//g")
  # do check repositories stuff
  checkBranch $r
}

# do check repositories stuff
checkBranch() {
  BRANCH="master"

  # $i is item in $r
  for i in $@
  do
    # get current branch name
    b=`cd $i && git branch | grep \*`
    echo "repo: $i"
    echo "current brunch: $b"

    # check branch
    if [[ $b != "* master" ]]
    then
      echo "!Error! $i is not on $BRANCH branch"
      echo "Current branch is $b"
      cd $i && git checkout $BRANCH && git branch && git pull origin $BRANCH
    else
      echo "Do pull stuff"
      cd $i && git branch && git pull origin $BRANCH
    fi
  done
  echo "Done. Congratulation, you win!"
}

findRepo $@