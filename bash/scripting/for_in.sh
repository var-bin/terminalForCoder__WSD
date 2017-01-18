#!/bin/bash

for i in 1 2 3 4 5
do
  file_name="file${i}.txt"
  if [[ -e "$file_name" ]]
  then
    continue
  fi
  echo "Creating file ${file_name}"
  touch "$file_name"
done
