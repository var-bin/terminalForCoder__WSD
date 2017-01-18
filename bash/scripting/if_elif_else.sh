#!/bin/bash

if [[ -f "$1" ]]
then
  echo "Removing file ${1}"
  rm "$1"
elif [[ -d "$1" ]]
then
  echo "Removing dir ${1}"
  rm -r "$1"
else
  echo "Can't remove ${1}"
fi
