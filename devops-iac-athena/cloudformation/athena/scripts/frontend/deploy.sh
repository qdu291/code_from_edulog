#!/bin/bash -eu

cd /opt/edulog/frontend
aws s3 cp s3://edulog-internal-shorterm/athena/athena-ui-build.tar.gz .
rm -rf dist
tar zxvf athena-ui-build.tar.gz

sudo rm -rf /var/www/html/*
sudo cp -rf dist/* /var/www/html

