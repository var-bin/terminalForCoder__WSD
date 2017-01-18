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

path_to_diff="${HOME}/<path_to_diff_directory>${branch}-${repository}.diff"

diff_live () {
  git diff "origin/live..master/${branch}" > "$path_to_diff"
}

attach_diff () {
  curl -D- -u "<ipa_username>":"<ipa_password>" -X POST -H "X-Atlassian-Token: no-check" -F "file=@${path_to_diff};type=text/x-diff" "https://jira.<project_name>.com/rest/api/2/issue/${issue_id}/attachments"
}

diff_live && attach_diff

# Usage: cd <repo_name> && attach_diff <issue_id>
# <issue_id> should include your company prefix (ABC, XYZ, XX, etc.)
# At instance, "attach_diff XYZ-135" will try to attach diff to https://jira.<project_name>.com/browse/XYZ-135
