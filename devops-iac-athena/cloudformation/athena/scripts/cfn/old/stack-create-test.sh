#!/bin/bash
region="us-east-2"
env="devleg"
stackName="athena-${env}"
vpc_stack_name="edulogvn-nonprod-vpc"
db_master_password="L8xzSk3iZI59"
default_cq_instance_id="i-0b7545fc9c879870b"
templateURL="https://edulogvn-devops.s3.us-east-2.amazonaws.com/iac/cloudformation/athena/${env}/templates/athena.yml"
s3_key_prefix="iac/cloudformation/athena/${env}"

cd /Users/tankhuu/GitHub/TanKhuu/karros-iac/cloudformation/athena/
aws s3 cp --recursive templates/ s3://edulogvn-devops/iac/cloudformation/athena/${env}/templates

aws --region $region cloudformation create-stack \
  --stack-name ${stackName} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} \
  --parameters \
    ParameterKey=Tenant,ParameterValue=${env} \
    ParameterKey=VPCStackName,ParameterValue=${vpc_stack_name} \
    ParameterKey=CFS3KeyPrefix,ParameterValue=${s3_key_prefix} \
    ParameterKey=DBMasterUserPassword,ParameterValue=${db_master_password} \
    ParameterKey=CQInstanceId,ParameterValue=${default_cq_instance_id}

