#!/bin/bash

envType=$1

be_host=$2

ssh_key=$3

if [ $envType = 'prod' ]; then
    awscmd="aws --profile prod";
else
    awscmd="aws";
fi


scp -i $ssh_key -o "StrictHostKeyChecking no" /usr/local/bin/add_additional_values.sh ubuntu@$be_host:/tmp/add_additional_values.sh

echo "chmod +x /tmp/add_additional_values.sh && sudo /bin/bash /tmp/add_additional_values.sh && exit && cat /opt/athena/env/athena.env" | ssh -i $ssh_key -o "StrictHostKeyChecking no" ubuntu@$be_host