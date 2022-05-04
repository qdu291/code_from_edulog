#!/bin/bash -xe

# CHECK PARAMS #
if [ $# -ne 2 ]; then
  echo $0: Usage: service_name build_version
  exit 1
fi

# VARIABLES #
ENV="stage"
SERVICE_NAME=$1
BUILD_VERSION=$2
S3_ARTIFACTS="edulogvn-artifacts"
BASE_DIR="/opt/athena/src"
VER_DIR="/opt/athena/versions"

# EXECUTE #
cd $BASE_DIR
# Backup previous version of service
cp -p $SERVICE_NAME.jar $SERVICE_NAME.bk.jar
# Pull service src from S3
aws s3 cp s3://${S3_ARTIFACTS}/athena/backend/${SERVICE_NAME}/${ENV}/${SERVICE_NAME}.jar .
# Versioning Service
cd $VER_DIR
echo "${BUILD_VERSION}" > ${SERVICE_NAME}
cat ${SERVICE_NAME}
