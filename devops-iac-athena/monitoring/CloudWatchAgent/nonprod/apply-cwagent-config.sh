#!/bin/bash -xe

PS_PREFIX="AmazonCloudWatch-athena"
. /opt/athena/env/athena.env
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:${PS_PREFIX}-${ENV}-${TENANT}
