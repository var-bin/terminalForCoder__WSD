#!/bin/bash
# clone vendors repositories to ./core/vendors
REPO_NAME="terminalForCoder__WSD"
PATH_TO_CORE="$HOME/$REPO_NAME/bash/core"

# array with repositories
repositories=( "https://github.com/larscmagnusson/CSS3MultiColumn.git" "https://github.com/tc39/test262.git" "https://github.com/postcss/postcss" "https://github.com/webpack/webpack" "https://github.com/var-bin/spriteFactory.git" "https://github.com/var-bin/backbone-training.git" "https://github.com/var-bin/flex-grid-framework.git" "https://github.com/var-bin/BrandButtons.git" "https://github.com/var-bin/less-easings.git" )

i=0 # start el
repositories_count=${#repositories[@]} # array size

cloneVendors() {
  if [[ ! -d "$PATH_TO_CORE/vendors" ]]
  then
    mkdir "$PATH_TO_CORE/vendors"
  fi

  while [ $i -lt $repositories_count ]
  do
    # Get vendor name
    vendor=$(echo ${repositories[$i]} | sed "s/https\:\/\/github\.com\/*//g" | sed "s/\/.*//g")
    vendor_repo_name=$(echo ${repositories[$i]} | sed "s/https\:\/\/github\.com\/.*\///g" | sed "s/\.git//g")

    if [[ -d "$PATH_TO_CORE/vendors/$vendor" ]]
    then
      echo "Directory $PATH_TO_CORE/vendors/$vendor is exist"

      cd "$PATH_TO_CORE/vendors/$vendor" && git clone ${repositories[$i]}
    else
      echo "Create directory: $PATH_TO_CORE/vendors/$vendor"
      echo "Repository: ${repositories[$i]} is clonning"

      mkdir "$PATH_TO_CORE/vendors/$vendor"

      cd "$PATH_TO_CORE/vendors/$vendor" && git clone ${repositories[$i]}
    fi
    i=$((i + 1))
  done
}

cloneVendors $@
