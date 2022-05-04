#!/bin/bash
region="us-east-2"
stackName="athena-prod-hallettsville"
aws --region $region cloudformation delete-stack --stack-name ${stackName}
  