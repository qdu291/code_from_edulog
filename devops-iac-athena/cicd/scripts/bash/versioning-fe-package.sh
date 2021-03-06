#!/bin/bash -xe

# CHECK VARIABLES #
if [ $# -ne 2 ]; then
  echo $0 Usage: versioning-fe-package build_version git_commit
  exit 1
fi

# VARIABLES #
BUILD_VERSION=$1
GIT_COMMIT=$2
S3_ARTIFACTS_BUCKET="edulogvn-artifacts"

# EXECUTE #
TAGS="{\"TagSet\":[{\"Key\":\"project\",\"Value\":\"athena\"},{\"Key\":\"service\",\"Value\":\"frontend\"},{\"Key\":\"author\",\"Value\":\"ktvn-devops\"},{\"Key\":\"environment\",\"Value\":\"stage\"},{\"Key\":\"git_commit\",\"Value\":\"${GIT_COMMIT}\"},{\"Key\":\"build_version\",\"Value\":\"${BUILD_VERSION}\"}]}"
# Versioning package
aws s3api put-object-tagging \
    --bucket $S3_ARTIFACTS_BUCKET \
    --key athena/frontend/build/${BUILD_VERSION}.tar.gz \
    --tagging $TAGS