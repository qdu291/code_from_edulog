#!/bin/bash -xe

# CHECK PARAMS #
if [ $# -ne 1 ]; then
  echo $0 Usage: deploy-aggregator ARTIFACT_PATH
  exit 1
fi

# VARIABLES #
ARTIFACT_PATH=$1
BASE_DIR="/opt/athena/src"

# EXECUTE #
mkdir -p /tmp/deploy-aggregator
cd /tmp/deploy-aggregator
aws s3 cp $ARTIFACT_PATH .
tar zxvf package.tar.gz
mv */* $BASE_DIR
rm -rf *
/usr/local/bin/restart-athena-services
