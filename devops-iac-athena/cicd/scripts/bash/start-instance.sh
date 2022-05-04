#!/bin/bash -xe
# Check variable
if [ $# -ne 1 ]; then
    echo $0: usage: start_instance instance_id
    exit 1
fi

# Variable
instance_id=$1

# Execute
echo "==> Start instance ${instance_id}"
aws ec2 start-instances --instance-ids $instance_id
if [ $? -ne 0 ]; then
  echo "==> Instance ${instance_id} started failed!!!"
  exit 1
fi
# Wait for instance status ok
echo "==> Waiting for instance status ok"
aws ec2 wait instance-status-ok --instance-ids $instance_id