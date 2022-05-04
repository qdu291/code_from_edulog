#!/bin/bash -xe

# Check Variables #
if [ $# -ne 7 ]; then
    echo $0: usage: git_user git_repo_name git_commit access_token state job_name build_number
    exit 1
fi

# Variables #
ci_url="http://athena-ci.karrostech.net/blue/organizations/jenkins"
git_user=$1
git_repo_name=$2
git_commit=$3
access_token=$4
state=$5
job_name=$6
build_number=$7

curl "https://api.GitHub.com/repos/${git_user}/${git_repo_name}/statuses/${git_commit}" \
  -H "Content-Type: application/json" \
  -H "Authorization: token ${access_token}" \
  -X POST \
  -d "{\"state\": \"${state}\",\"context\": \"ci/jenkins\", \"description\": \"Jenkins\", \"target_url\": \"${ci_url}/${job_name}/detail/${job_name}/${build_number}/pipeline\"}"