#!/usr/bin/env bash
# if [ $# -ne 2 ]; then
#     echo $0: usage: webs-stack-create-changeset.sh stackName imageId
#     exit 1
# fi
stackName="edulog-athena-halletsville-database"
vpcStackName="edulog-vpc"
sgStackName="edulog-securitygroups"
imageId="ami-07ebfd5b3428b6f4d"
email="tan.khuu@karrostech.com"
keyPair="edulog-vn-devops"
instanceType="t2.micro"
templateBody="file://../templates/postgresql.yaml"
aws cloudformation create-stack \
  --stack-name ${stackName} \
  --capabilities CAPABILITY_IAM \
  --template-body ${templateBody} \
  --parameters \
    ParameterKey=VPCStackName,ParameterValue=${vpcStackName} \
    ParameterKey=SGStackName,ParameterValue=${sgStackName} \
    ParameterKey=PostgreSQLImageId,ParameterValue=${imageId} \
    ParameterKey=PostgreSQLInstanceType,ParameterValue=${instanceType} \
    ParameterKey=NotificationEmail,ParameterValue=${email} \
    ParameterKey=KeyPair,ParameterValue=${keyPair}