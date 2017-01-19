#!/bin/bash

PATH_TO_DIFF_DIR="${HOME}/diff/"
FILE_EXTENTION=".diff"

USER_NAME="<ipa_user_name>"
USER_PASSWORD="<ipa_user_password>"
PROJECT_NAME="<project_name>"

# if "$1" is empty
if [ -z "$1" ]
then
  echo "Please, specify an issue ID"
  exit 0
fi

issue_id="$1"
branch=$(git rev-parse --abbrev-ref HEAD)

# Get the first line of git remote output and cut a path to repository
repository=$(git remote -v | head -n1 | sed "s/^origin.*\/\(.*\)\.git\s(.*)/\1/")
file_name="${branch}-${repository}${FILE_EXTENTION}"

# path to diff directory with <filename>.diff
path_to_diff="${PATH_TO_DIFF_DIR}${file_name}"

diff_master() {
  git diff "origin/master origin/${branch}" > "$path_to_diff"
}

attach_diff() {
  curl -D -u "${USER_NAME}":"${USER_PASSWORD}" -X POST -H "X-Atlassian-Token: no-check" -F "file=@${path_to_diff};type=text/x-diff" "https://jira.${PROJECT_NAME}.com/rest/api/2/issue/${issue_id}/attachments"
}

diff_master && attach_diff

# Usage: cd <repo_name> && fast_diff_v2.sh <issue_id>
# <issue_id> should include your company prefix (ABC, XYZ, XX, etc.)
# At instance, "fast_diff_v2.sh XYZ-135" will try to attach diff to https://jira.<project_name>.com/browse/XYZ-135
