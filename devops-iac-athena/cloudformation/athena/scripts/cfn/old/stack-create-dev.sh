#!/bin/bash
region="us-east-2"
env="dev"
stackName="athena-${env}"
vpc_stack_name="edulogvn-nonprod-vpc"
db_master_password="rU18iWV4qxKU"
templateURL="https://edulogvn-devops.s3.us-east-2.amazonaws.com/iac/cloudformation/athena/${env}/templates/athena.yml"

cd /Users/tankhuu/GitHub/Karros/edulog-iac/cloudformation/athena/
aws s3 cp --recursive templates/ s3://edulogvn-devops/iac/cloudformation/athena/dev/templates

aws --region $region cloudformation create-stack \
  --stack-name ${stackName} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} 
  --parameters \
    ParameterKey=Tenant,ParameterValue=${env} \
    ParameterKey=VPCStackName,ParameterValue=${vpc_stack_name} \
    ParameterKey=DBMasterUserPassword,ParameterValue=${db_master_password} 