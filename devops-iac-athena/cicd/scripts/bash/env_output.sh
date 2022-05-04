#!/bin/bash

# Variable
TENANT=$1
TENANT_ID=$TENANT_ID
CREATION_TIME=$CREATION_TIME
S3_TENANT=$S3_TENANT
ADMIN_USER=$EMAIL

# Tenant Name
echo "Tenant Name: ${TENANT}"
#echo "Tenant Name: ${TENANT}" > $TENANT.txt

# Get RDS Endpoints
export RDSENDPOINT=`python3 ../python/get_output_from_stack.py athena-$TENANT RDSEndpoint`
#echo "RDS Endpoints: ${RDSENDPOINT}"

# Get FrontEnd URL
export FRONTENDURL=`python3 ../python/get_output_from_stack.py athena-$TENANT FrontendURL`
echo "FrontEnd URL: ${FRONTENDURL}"
#echo "FrontEnd URL: ${FRONTENDURL}" >> $TENANT.txt

# Get BackEnd URL
export BACKENDURL=`python3 ../python/get_output_from_stack.py athena-$TENANT BackendURL`
echo "BackEnd URL: ${BACKENDURL}"
#echo "BackEnd URL: ${BACKENDURL}" >> $TENANT.txt

# Get Tenant ID
echo "Tenant ID: ${TENANT_ID}"
#echo "Tenant ID: ${TENANT_ID}" >> $TENANT.txt

# Creation Time
echo "Creation Time: ${CREATION_TIME}"
#echo "Creation Time: ${CREATION_TIME}" >> $TENANT.txt

# Creation Time
echo "Admin User: ${ADMIN_USER}"
#echo "Admin User: $ADMIN_USER" >> $TENANT.txt

# Put tenant information to json file
echo {\"tenant_name\": \"${TENANT}\", \"rds_endpoint\": \"$RDSENDPOINT\", \"frontend_url\": \"$FRONTENDURL\", \"backend_url\": \"$BACKENDURL\", \"tenant_id\": \"$TENANT_ID\", \"creation_time\": \"$CREATION_TIME\", \"admin_user\": \"$ADMIN_USER\" } > $TENANT.json

# Copy $TENANT.txt file to s3
aws s3 cp $TENANT.json $S3_TENANT