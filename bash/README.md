# bash

### Preface
Когда вы запускаете терминал, внутри него работает специальная программа- оболочка - `shell` (англ) - интерпретатор команд. Shell понимает все команды которые вы вводите с клавиатуры и обрабатывает их. Также выводит сообщения об ошибках, следит за корректностью команд и их синтаксисом. Примером таких команд могут быть: переход в папку, создать новую директорию, добавить текстовый файл, отредактировать его, сохранить изменения. Программ-оболочек довольно много. Одна их первых удачных реализаций называется sh - ее разработал Стивен Борн в 1977 году ([wiki](https://ru.wikipedia.org/wiki/Bourne_shell)). Эта оболочка шла в составе 7го издания `ОС Unix`. Данная оболочка является де-факто стандартом и доступна почти в любом дистрибутиве `*nix`. В 1989 году появилась усовершенствованная и модернизированная версия `sh - bash (Bourne again shell)`. Почему `bash` спросите вы. И такой вопрос будет уместен. Все просто - в 99% случаев когда вы садитесь за компьютер, который работает на `OS Unix`, оболочка по умолчанию, которая обрабатывает команды пользователя будет `bash`. Конечно, есть еще такая оболочка как `zsh`, но это уже совсем другая история.

```bash
  which bash # где находится bash
```

### Основы
```bash
  #!/bin/bash # начало любого скрипта на bash
```

#### Перменные
  - **имя** = буквы, цифры, _ (нижнее подчеркивание).
  - **имя** не может начинаться с цифры.
  - **значение:** числа, строки (если есть пробелы, то в кавычках), отдельные символы.

**Создание (перезапись) переменной:**
```bash
  path=~/Docs
```

**Чтение переменной:**
```bash
  $path или ${path}
```

**Передача аргументов скрипту:**
```bash
  ./script.sh arg1 arg2 arg3 … argN
```

**Обработка внутри скрипта:**
```bash
  $1 # первый аргумент
  $2 # второй аргумент
  $0 # имя скрипта
  $# # количество аргументов
```

**Hello, world!** `*`
```bash
  #!/bin/bash
  echo "Hello, world!"

  ./hw.sh # вызов
```

**Еще один пример, поработаем с переменными:**
```bash
  #!/bin/bash

  var1=$1
  var2=$2

  echo "Arguments are \$1=$var1 \$2=$var2"

  ./variables.sh var1 var2 # вызов
```
> `*` Чтобы выполнить файл ему нужно дать на это разрешение:
```bas
  chmod +x filename.sh
```

#### Ветвления

**if**
```bash
  if [[ condition ]]
  then
    # action, if condition is true
  fi
```

* * *
**Условия (строки):**
```bash
  -z <string> # string is empty
  -n <string> # string is not empty
  <str1> == <str2> # strings are equal
  <str1> != <str2> # strings are not equal
```

**Условия (числа/строки):**
```bash
  <число/строка> операция <число/строка>
  -eq, (==) # equal
  -ne, (!=) # not equal
  -lt, (<) # less than
  -le # less than or equal
  -gt, (>) # more than
  -ge # more than or equal
```

**Условия (файлы):**
```bash
  -e <path> # path is exist
  -f <path> # is file
  -d <path> # is directory
  -s <path> # file size more than 0
  -x <path> # file is executable
```

**Условия (логические):**
```bash
  ! # denial of boolean expression
  && # boolean “and”
  || # boolean “or”
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

#### Циклы

**for/in**
```bash
  for i in array
  do
    # дейтсвие, переменная i каждый раз принимает
    # следующее значение из array
  done

  break # прервать выполнение цикла
  continue # перейти на следующее значени переменной i
```

**while**
```bash
  while [[ condition ]]
  do
    # action, while condition is true
  done
```

**while пример:**
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

### Автоматизация рутинных задач

#### Быстрый дифф
```bash
  git diff origin/master origin/%branch-name% > ~/%path_to_directory%/diff/diff-%branch-name%.diff

  %branch-name% # имя ветки для которой нужно создать diff
  %path_to_directory% # имя папки куда сохранять файл с diff'ом
```

#### Быстрый дифф + `Jira API`
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

#### Up большого количества репозиториев

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
    path_to_vendor_repo="$HOME/terminalForCoder__WSD/bash/core/vendors/"
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

#### Полезные алиасы

```bash
  # User specific aliases and functions
  # added by rybka
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
