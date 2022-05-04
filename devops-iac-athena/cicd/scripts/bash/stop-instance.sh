#!/bin/bash -xe
# Check variable
if [ $# -ne 1 ]; then
    echo $0: usage: stop_instance instance_id
    exit 1
fi

# Variable
instance_id=$1

# Execute
aws ec2 stop-instances --instance-ids $instance_id
if [ $? -ne 0 ]; then
    echo "Instance ${instance_id} stopped failed!!!"
    exit 1
fi
# Wait for instance status ok
aws ec2 wait instance-stopped --instance-ids $instance_id
