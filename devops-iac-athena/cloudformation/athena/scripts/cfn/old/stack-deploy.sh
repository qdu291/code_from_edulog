#!/bin/bash

cd /Users/tankhuu/GitHub/Karros/edulog-iac/cloudformation/athena/

sh scripts/stack-delete.sh

aws s3 cp --recursive templates/ s3://edulogvn-devops/iac/cloudformation/athena/templates

sh scripts/stack-create.sh