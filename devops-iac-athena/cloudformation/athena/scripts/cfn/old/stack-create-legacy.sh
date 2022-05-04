#!/bin/bash -xe

# Check variables #
if [ $# -ne 7 ]; then
  echo $0 Usage: stack-create-legacy env tenant vpc_stack_name db_master_password fe_version be_version db_snapshot_id
  exit 1
fi

# Example: sh stack-create-legacy.sh stage stageleg edulogvn-nonprod-vpc L8xzSk3iZI59 fe_version ami-086eb3642d53ef8f0 rds:athena-devleg-rds-2020-06-14-09-05

# Variables #
env=$1 # "prod"
tenant=$2 # "ktvn"
vpc_stack_name=$3 # edulogvn-prod-vpc  | edulogvn-nonprod-vpc
db_master_password=$4
fe_version=$5 # FE-1.0.0
be_version=$6 # BE-1.0.0
db_snapshot_id=$7

region="us-east-2"
stack_name="athena-${tenant}"
s3_bucket="edulogvn-devops"
s3_key_prefix="iac/cloudformation/athena/${tenant}"
templateDir="/Users/tankhuu/GitHub/TanKhuu/karros-iac/cloudformation/athena/"
templateURL="https://${s3_bucket}.s3.us-east-2.amazonaws.com/${s3_key_prefix}/templates/athena.yml"

# Execute #
# Backend Release Version
be_ami_id=$be_version

# Upload templates for environment
cd $templateDir
aws s3 cp --recursive templates/ s3://${s3_bucket}/${s3_key_prefix}/templates

# Create Stack
aws --region $region cloudformation create-stack \
  --stack-name ${stack_name} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} \
  --tags \
    Key=environment,Value=${env} \
    Key=project,Value=athena \
    Key=author,Value=ktvn-devops \
    Key=tenant,Value=${tenant} \
  --parameters \
    ParameterKey=Tenant,ParameterValue=${tenant} \
    ParameterKey=VPCStackName,ParameterValue=${vpc_stack_name} \
    ParameterKey=CFS3KeyPrefix,ParameterValue=${s3_key_prefix} \
    ParameterKey=DBMasterUserPassword,ParameterValue=${db_master_password} \
    ParameterKey=DBSnapshotIdentifier,ParameterValue=${db_snapshot_id} \
    ParameterKey=BackendAMIId,ParameterValue=${be_ami_id} 

# Wait for stack creation
aws --region $region cloudformation wait stack-create-complete --stack-name $stack_name

# Get CQ Instance Private IP

# Update Stack with new CQ Private IP

# Deploy Frontend Release version
# aws s3 cp --acl public-read --recursive s3://athena-devleg.karrostech.io/ s3://athena-stageleg.karrostech.io/

# Suspend CQ & BE ASG