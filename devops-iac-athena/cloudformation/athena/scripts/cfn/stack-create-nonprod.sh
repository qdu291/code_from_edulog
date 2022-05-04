#!/bin/bash
region="us-east-2"
env="nonprod"
tenant="rltest"
project="athena"
stack_name="${project}-${tenant}"
vpc_stack_name="edulogvn-nonprod-vpc"
db_master_password="L8xzSk3iZI59"

# Frontend Parameters
fe_domain="etstack.io"
fe_hostedzone_id="Z12KP7UYAVP23S"
fe_sslcertificate_id="arn:aws:acm:us-east-1:690893158275:certificate/9dce5e22-6e5e-470f-9b42-3d7862df8690"

# Backend Parameters
be_domain="etstack.io"
be_hostedzone_id="Z12KP7UYAVP23S"
be_sslcertificate_id="arn:aws:acm:us-east-1:690893158275:certificate/9dce5e22-6e5e-470f-9b42-3d7862df8690"

# Backend Parameters
be_ami_id="ami-01e133361a0536476"

# Database Parameters
db_snapshot_id="rds:athena-redlake-rds-2020-09-02-09-04"

# master template directory
master_template="../../templates/athena.yml"
output_master_template="athena.${tenant}.yaml"
s3_bucket="edulogvn-devops"
s3_prefix="iac/cloudformation/athena/${env}/${tenant}"

# Package Templates
aws --region $region cloudformation package --template-file $master_template \
  --s3-bucket $s3_bucket --s3-prefix $s3_prefix \
  --force-upload \
  --output-template-file $output_master_template

# Upload templates for environment
aws s3 cp $output_master_template s3://${s3_bucket}/${s3_prefix}/${output_master_template}
templateURL="https://${s3_bucket}.s3.us-east-2.amazonaws.com/${s3_prefix}/${output_master_template}"

# Create Stack
aws --region $region cloudformation create-stack \
  --stack-name ${stack_name} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} \
  --tags \
    Key=environment,Value=${env} \
    Key=project,Value=${project} \
    Key=author,Value=ktvn-devops \
    Key=tenant,Value=${tenant} \
  --parameters \
    ParameterKey=Tenant,ParameterValue=${tenant} \
    ParameterKey=Env,ParameterValue=${env} \
    ParameterKey=VPCStackName,ParameterValue=${vpc_stack_name} \
    ParameterKey=DBMasterUserPassword,ParameterValue=${db_master_password} \
    ParameterKey=DBSnapshotIdentifier,ParameterValue=${db_snapshot_id} \
    ParameterKey=BackendAMIId,ParameterValue=${be_ami_id}  \
    ParameterKey=FEDomain,ParameterValue=${fe_domain}  \
    ParameterKey=FEHostedZoneId,ParameterValue=${fe_hostedzone_id} \
    ParameterKey=FESSLCertificateId,ParameterValue=${fe_sslcertificate_id} \
    ParameterKey=BEDomain,ParameterValue=${be_domain}  \
    ParameterKey=BEHostedZoneId,ParameterValue=${be_hostedzone_id} \
    ParameterKey=BESSLCertificateId,ParameterValue=${be_sslcertificate_id}  

# Wait for stack creation

# Get CQ Instance Private IP

# Update Stack with new CQ Private IP

# Deploy Frontend Release version