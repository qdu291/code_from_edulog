#!/bin/bash -xe

env_type=$1
tenant=$2
stack_name=$3
fe_url=$4
fe_cf_id=$5
wq_url=$6
wq_cf_id=$7
be_url=$8
rds_endpoint=$9
db_pass=$10
nos_host=$11
region=$12

AWS_CMD='aws'
if [ $env_type = 'prod' ]; then
  AWS_CMD='aws --profile prod'
fi
if [ $region = 'paris' ]; then
  AWS_CMD="$AWS_CMD --region eu-west-3"
fi

# Add environment information into SSM Parameter Store
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/fe_url\",\"Value\":\"$fe_url\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/fe_cf_id\",\"Value\":\"$fe_cf_id\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/wq_url\",\"Value\":\"$wq_url\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/wq_cf_id\",\"Value\":\"$wq_cf_id\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/be_url\",\"Value\":\"$be_url\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/rds_endpoint\",\"Value\":\"$rds_endpoint\",\"Type\":\"String\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/db_pass\",\"Value\":\"$db_pass\",\"Type\":\"SecureString\"}"
$AWS_CMD ssm put-parameter --overwrite --cli-input-json "{\"Name\":\"/edulog/athena/$env_type/$tenant/nos_host\",\"Value\":\"$nos_host\",\"Type\":\"SecureString\"}"
