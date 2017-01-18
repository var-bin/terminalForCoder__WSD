#!/bin/bash

# ./case_in_esac.sh 2 1
# Creating dir 1
# ./case_in_esac.sh 1 2
# Creating file 2

if [[ "$#" -ne 2 ]]
then
  echo "You should specify exactly two arguments!"
else
  case "$1" in
  1)
    echo "Creating file ${2}"
    touch "$2"
  ;;
  2)
    echo "Creating dir ${2}"
    mkdir "$2"
  ;;
  *)
    echo "Wrong value"
  esac
fi
