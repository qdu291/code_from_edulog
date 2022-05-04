#!/bin/bash
# Check variable
if [ $# -ne 2 ]; then
    echo $0: usage: update-cfn-stack env ami_id
    exit 1
fi

env=$1
backend_ami_id=$2
region="us-east-2"
stackName="athena-${env}"
templateURL="https://edulogvn-devops.s3.us-east-2.amazonaws.com/iac/cloudformation/athena/${env}/templates/athena.yml"

aws --region $region cloudformation update-stack \
  --stack-name ${stackName} \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --template-url ${templateURL} \
  --parameters \
    ParameterKey=BackendAMIId,ParameterValue=$backend_ami_id \
    ParameterKey=Tenant,UsePreviousValue=true \
    ParameterKey=CFS3BucketName,UsePreviousValue=true \
    ParameterKey=CFS3BucketRegion,UsePreviousValue=true \
    ParameterKey=CFS3KeyPrefix,UsePreviousValue=true \
    ParameterKey=VPCStackName,UsePreviousValue=true \
    ParameterKey=FEHostedZoneId,UsePreviousValue=true \
    ParameterKey=BEHostedZoneId,UsePreviousValue=true \
    ParameterKey=KeyPairName,UsePreviousValue=true \
    ParameterKey=DBAllocatedStorage,UsePreviousValue=true \
    ParameterKey=DBInstanceClass,UsePreviousValue=true \
    ParameterKey=DBIops,UsePreviousValue=true \
    ParameterKey=DBMasterUserPassword,UsePreviousValue=true \
    ParameterKey=DBMasterUsername,UsePreviousValue=true \
    ParameterKey=DBMultiAZ,UsePreviousValue=true \
    ParameterKey=DBSnapshotIdentifier,UsePreviousValue=true \
    ParameterKey=DBParameterGroupName,UsePreviousValue=true \
    ParameterKey=DBStorageType,UsePreviousValue=true \
    ParameterKey=DBBackupRetentionPeriod,UsePreviousValue=true \
    ParameterKey=CQAMIID,UsePreviousValue=true \
    ParameterKey=CQInstanceType,UsePreviousValue=true \
    ParameterKey=CQASGMinSize,UsePreviousValue=true \
    ParameterKey=CQASGMaxSize,UsePreviousValue=true \
    ParameterKey=CQASGDesiredCapacity,UsePreviousValue=true \
    ParameterKey=CacheUser,UsePreviousValue=true \
    ParameterKey=CachePassword,UsePreviousValue=true \
    ParameterKey=QueueUser,UsePreviousValue=true \
    ParameterKey=QueuePassword,UsePreviousValue=true \
    ParameterKey=BackendInstanceType,UsePreviousValue=true \
    ParameterKey=BEASGMinSize,UsePreviousValue=true \
    ParameterKey=BEASGMaxSize,UsePreviousValue=true \
    ParameterKey=BEASGDesiredCapacity,UsePreviousValue=true \
    ParameterKey=BESSLCertificateId,UsePreviousValue=true \
    ParameterKey=BEDBUser,UsePreviousValue=true \
    ParameterKey=BEDBPassword,UsePreviousValue=true \
    ParameterKey=FEDomain,UsePreviousValue=true \
    ParameterKey=BEDomain,UsePreviousValue=true \
    ParameterKey=CQPrivateIP,UsePreviousValue=true \
    ParameterKey=FESSLCertificateId,UsePreviousValue=true

# Wait for cfn update finished
aws --region $region cloudformation wait stack-update-complete --stack-name $stackName
