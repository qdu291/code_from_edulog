#!/bin/bash
region="us-east-2"
env="edulog"
stackName="athena-${env}"
templateURL="https://edulogvn-devops.s3.us-east-2.amazonaws.com/iac/cloudformation/athena/${env}/templates/athena.yml"
s3_key_prefix="iac/cloudformation/athena/${env}"
vpc_stack_name="edulogvn-prod-vpc"
db_master_password="2ASU0sGt9UXz"

# Frontend Parameters
fe_domain="etstack.io"
fe_hostedzone_id="Z12KP7UYAVP23S"
fe_sslcertificate_id="arn:aws:acm:us-east-1:690893158275:certificate/9dce5e22-6e5e-470f-9b42-3d7862df8690"

# Backend Parameters
be_ami_id="ami-0ba39d554eeb63f4f"

# Database Parameters
db_snapshot_id="rds:athena-demo-rds-2020-06-21-09-01"



# Upload templates for environment
cd /Users/tankhuu/GitHub/Karros/devops-iac-athena/cloudformation/athena/
aws s3 cp --recursive templates/ s3://edulogvn-devops/iac/cloudformation/athena/${env}/templates

# Create Stack
aws --region $region cloudformation create-stack \
  --stack-name ${stackName} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} \
  --tags \
    Key=environment,Value=prod \
    Key=project,Value=athena \
    Key=author,Value=ktvn-devops \
    Key=tenant,Value=${env} \
  --parameters \
    ParameterKey=Tenant,ParameterValue=${env} \
    ParameterKey=VPCStackName,ParameterValue=${vpc_stack_name} \
    ParameterKey=CFS3KeyPrefix,ParameterValue=${s3_key_prefix} \
    ParameterKey=DBMasterUserPassword,ParameterValue=${db_master_password} \
    ParameterKey=DBSnapshotIdentifier,ParameterValue=${db_snapshot_id} \
    ParameterKey=BackendAMIId,ParameterValue=${be_ami_id}  \
    ParameterKey=FEDomain,ParameterValue=${fe_domain}  \
    ParameterKey=FEHostedZoneId,ParameterValue=${fe_hostedzone_id} \
    ParameterKey=FESSLCertificateId,ParameterValue=${fe_sslcertificate_id}  

# Wait for stack creation

# Get CQ Instance Private IP

# Update Stack with new CQ Private IP

# Deploy Frontend Release version