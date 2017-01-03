# bash

### Preface
Every time you launch a terminal, it starts to run the shell - a special program that interprets and processes command-lines taken from your keyboard. The shell also detects errors and monitors compliance of the commands and with their syntax. Some of the examples of these commands include opening a folder, creating a directory, adding, editing and saving text files. Actually, there are many other command-line interpreters out there. Developed by Stephen Bourne in 1977 ([`sh`](https://en.wikipedia.org/wiki/Bourne_shell)) is known to be one of the first and successful release of the shell. It was a part of Version 7 OS Unix and is commonly considered a de facto standard for any `*nix` distributive. In 1989 the world witnessed its upgraded version under a new name - `sh - bash (Bourne again shell)`. You're likely to ask why bash and the question would be quite to the point, although here's all pretty simple. In 99% `OS Unix` driven computers use bash as the default shell. You can also find the `zsh`, but that’s a completely different story.

```bash
  which bash # where is placed bash
```

### Basics
```bash
  #!/bin/bash # the beginning of any script on bash
```

#### Variables
  - **name**: letters, numbers, _ (underscore).
  - **name** - it cannot start with a number.
  - **value**: numbers, strings (if there is any whitespace - wrap it into double quotes), characters.

**Create (rewrite) variable:**
```bash
  path=~/Docs
```

**Read variable:**
```bash
  $path или ${path}
```

**Pass arguments to a script:**
```bash
  ./script.sh arg1 arg2 arg3 … argN
```

**Processing arguments within the script:**
```bash
  $1 # first argument
  $2 # second argument
  $0 # name of script
  $# # count of arguments
```

**Hello, world!** `*`
```bash
  #!/bin/bash
  echo "Hello, world!"

  ./hw.sh # how it calls
```

**Another one example of working with variables:**
```bash
  #!/bin/bash

  var1=$1
  var2=$2

  echo "Arguments are \$1=$var1 \$2=$var2"

  ./variables.sh var1 var2 # how it calls
```
> `*` Edit a permit for a file:
```bash
  chmod +x filename.sh
```

#### Conditions to execute different branches of code

**if**
```bash
  if [[ condition ]]
  then
    # an action, if condition is true
  fi
```

* * *
**Conditions (strings):**
```bash
  -z <string> # string is empty
  -n <string> # string is not empty
  <str1> == <str2> # strings are equal
  <str1> != <str2> # strings are not equal
```

**Conditions (numbers/strings):**
```bash
  <numbers/strings> operation <numbers/strings>
  -eq, (==) # equal
  -ne, (!=) # not equal
  -lt, (<) # less than
  -le # less than or equal
  -gt, (>) # more than
  -ge # more than or equal
```

**Conditions (files):**
```bash
  -e <path> # path is exist
  -f <path> # is file
  -d <path> # is directory
  -s <path> # file size more than 0
  -x <path> # file is executable
```

**Conditions (boolean):**
```bash
  ! # denial of boolean expression
  && # boolean "and"
  || # boolean "or"
```
* * *

**if/else:**
```bash
  if [[ condition ]]
  then
    # action, if condition is true
  else
    # action, if condition is false
  fi
```

**if/elif/else**
```bash
  #!/bin/bash

  if [[ -f $1 ]]
  then
    echo "Removing file"
    rm $1
  elif [[ -d $1 ]]
  then
    echo "Removing dir"
    rm -r $1
  else
    echo "Can't remove $1"
  fi
```


**case/in/esac**
```bash
  #!/bin/bash

  if [[ $# -ne 2 ]]
  then
   echo "You should specify exactly two arguments!"
  else
   case $1 in
    1)
     echo "Creating file $2"
     touch $2
    ;;
    2)
     echo "Creating dir $2"
     mkdir $2
    ;;
    *)
     echo "Wrong value"
   esac
  fi
```

#### Loops for repeated code

**for/in**
```bash
  for i in array
  do
    # an action, i on every iteration is getting
    # the next value from array
  done

  break # break loop
  continue # go to the next value of i
```

**while**
```bash
  while [[ condition ]]
  do
    # an action, while condition is true
  done
```

**while example:**
```bash
  # while.sh
  #!/bin/bash

  again="yes"
  while [ "$again" = "yes" ]
  do
   echo "Please enter a name:"
 >  read name
   echo "The name you entered is $name"

   echo "Do you wish to continue? (yes/no)"
   read again
  done
```

### Routine tasks automation

#### Fast diff
```bash
  git diff origin/master origin/%branch-name% > ~/%path_to_directory%/diff/diff-%branch-name%.diff

  %branch-name% # name of the branch to which you want to create a diff
  %path_to_directory% # the name of the folder where to save the file with diff
```

#### Fast diff + `Jira API`
```bash
  #!/bin/bash

  if [ -z "$1" ]
  then
    echo "Please, specify an issue ID"
    exit 1
  fi

  issue_id="$1"
  branch=$(git rev-parse --abbrev-ref HEAD)

  # Get the first line of git remote output and cut a path to repository
  repository=$(git remote -v | head -n1 | sed "s/^origin.*\/\(.*\)\.git\s(.*)/\1/")

  path_to_diff="$HOME/<path_to_diff_directory>$branch-$repository.diff"

  diff_live () {
    git diff "origin/live..master/$branch" > "$path_to_diff"
  }

  attach_diff () {
    curl -D- -u "<ipa_username>":"<ipa_password>" -X POST -H "X-Atlassian-Token: no-check" -F "file=@$path_to_diff;type=text/x-diff" "https://jira.<project_name>.com/rest/api/2/issue/$issue_id/attachments"
  }

  diff_live && attach_diff

  # Usage: cd <repo_name> && attach_diff <issue_id>
  # <issue_id> should include your company prefix (ABC, XYZ, XX, etc.)
  # At instance, "attach_diff XYZ-135" will try to attach diff to https://jira.<project_name>.com/browse/XYZ-135
```

#### Up a large number of repositories

:bangbang: Before start working with `./scripting/up_repo.sh` run `./clone_vendors.sh` :bangbang:

```bash
  #!/bin/bash

  # up_repo.sh - check repositories in core/vendor
  # find all directories that included .git
  # If any repo hasn't switched on master branch
  # than git checkout master && git branch && git pull
  # else git branch && git pull

  # get list of repositories
  findRepo() {
    REPO_NAME="terminalForCoder__WSD"
    path_to_vendor_repo="$HOME/$REPO_NAME/bash/core/vendors/"
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
```

#### Helpful aliases

```bash
  # User specific aliases and functions
  alias gst='git status'
  alias gf='git fetch'
  alias gm='git merge'
  alias gd='git diff'
  alias gb='git branch'
  alias gbm='git branch --merged'
  alias gcm='git commit -m'
  alias gp='git push origin'
  alias gbd='git branch -D'
  alias gshorth='git log -p -2'
  alias gch='git checkout'
  alias grntds='./grunt deploySync'
  alias grntd='./grunt deploy'
  alias ghide='git stash'
  alias gshow='git stash pop'
  alias gsl='git stash list'
  alias myps='ps aux | grep rybka'
  alias gmom='git merge origin/master'
  alias gad='git add'
  alias grm='git rm'
  alias showaliases='cat $HOME/.bashrc | grep alias'
```
