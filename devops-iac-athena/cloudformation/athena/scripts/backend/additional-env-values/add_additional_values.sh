#!/bin/bash -xe
  
# Adding additional environment values into /opt/athena/env/athena.env

# Variables
bucket_nonprod="s3://edulog-athena-backend/athena-env/additional_values"
bucket_prod="s3://athena-backend-env/athena-env/additional_values"

# Go working dir
cd /opt/athena/env
ls -al
# Get env
envtemp=$(head -n 1 athena.env)
echo $envtemp
env=$(echo $envtemp | cut -d'=' -f 2)
echo $env
#counting current numbers of values
curr_values=$(cat ./athena.env | wc -l)
echo $curr_values
if [ $curr_values -lt 24 ]; then
  #download from S3 bucket
  if [ $env = "nonprod" ]; then
    s3bucket=${bucket_nonprod}
  else
    s3bucket=${bucket_prod}
  fi

  echo ${s3bucket}

  aws s3 cp ${s3bucket} .
  #Add env file
  pwd
  cat ./additional_values >> athena.env
fi