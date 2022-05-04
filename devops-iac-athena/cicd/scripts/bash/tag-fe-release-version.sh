#!/bin/bash -xe


# VARIABLES #
S3_ARTIFACTS_BUCKET="edulogvn-artifacts"
S3_URI="s3://${S3_ARTIFACTS_BUCKET}/athena/frontend"

# EXECUTE #
TAGS="{\"TagSet\":[{\"Key\":\"project\",\"Value\":\"athena\"},{\"Key\":\"service\",\"Value\":\"frontend\"},{\"Key\":\"author\",\"Value\":\"ktvn-devops\"},{\"Key\":\"type\",\"Value\":\"release\"},{\"Key\":\"build_version\",\"Value\":\"${BUILD_VERSION}\"}]}"
# COPY BUILD_VERSION TO RELEASE_VERSION
aws s3 cp ${S3_URI}/build/${BUILD_VERSION}.tar.gz ${S3_URI}/release/${RELEASE_VERSION}.tar.gz
# TAG RELEASE_VERSION
aws s3api put-object-tagging \
    --bucket $S3_ARTIFACTS_BUCKET \
    --key athena/frontend/release/${RELEASE_VERSION}.tar.gz \
    --tagging $TAGS
