#!/bin/bash

prof="$1"
env="$2"
siteName="$3"
be_ip="$4"

if [ "$env" == "prod" ]; then
  es_endpoint="snapshot-sync-prod.karrostech.net:10401/snapshotLoad"
else
  es_endpoint="snapshot-sync-nonprod.karrostech.net:10401/snapshotLoad"
fi

tenantID=$(aws --profile ${prof} cloudformation describe-stacks --stack-name athena-${siteName} --query "Stacks[0].Parameters[?ParameterKey=='TenantId'].ParameterValue" --output text)
echo "Tenant ID of ${siteName} is: ${tenantID}"
echo "Posting document to ES: ${es_endpoint}"

curl -s -X POST -H "Content-Type: application/json" ${es_endpoint} -d "{\"ipAddr\": \"${be_ip}\",\"tenantId\": \"${tenantID}\",\"entity\": \"run\"}"
sleep 5
curl -s -X POST -H "Content-Type: application/json" ${es_endpoint} -d "{\"ipAddr\": \"${be_ip}\",\"tenantId\": \"${tenantID}\",\"entity\": \"route\"}"
sleep 5
curl -s -X POST -H "Content-Type: application/json" ${es_endpoint} -d "{\"ipAddr\": \"${be_ip}\",\"tenantId\": \"${tenantID}\",\"entity\": \"trip\"}"
