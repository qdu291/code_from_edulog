#!/bin/bash -xe

# CHECK PARAMS #
if [ $# -ne 1 ]; then
  echo $0 Usage: deploy-services build_version
  exit 1
fi

# VARIABLES #
ENV='dev'
BUILD_VERSION=$1
BASE_DIR="/opt/athena/src"
S3_BUCKET="edulogvn-artifacts"

# EXECUTE #
cd /tmp
aws s3 cp s3://${S3_BUCKET}/athena/backend/services/${ENV}/${BUILD_VERSION}.tar.gz .
tar zxvf ${BUILD_VERSION}.tar.gz
mv ${BUILD_VERSION}/* $BASE_DIR
/usr/local/bin/restart-athena-services

# CLEANUP #
rm -rf ${BUILD_VERSION}
rm -f ${BUILD_VERSION}.tar.gz


