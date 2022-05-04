#!/bin/bash
DEBEZIUM_CLUSTER_ENDPOINT=$1
siteName=$2

# Checking does ${siteName} exist
curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT} | grep ${siteName} >> /dev/null

if [ $? != 0 ]
then
  echo "==> Connectors of Site ${siteName} not be created"
else
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-trip-master-connector/status  | json_pp -json_opt pretty,canonical
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-student-connector/status | json_pp -json_opt pretty,canonical
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-school-connector/status | json_pp -json_opt pretty,canonical
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-run-connector/status  | json_pp -json_opt pretty,canonical
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-route-connector/status  | json_pp -json_opt pretty,canonical
  curl -s -X GET ${DEBEZIUM_CLUSTER_ENDPOINT}/athena-${siteName}-transport-request-connector/status  | json_pp -json_opt pretty,canonical
fi