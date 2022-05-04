#!/bin/bash -eu

env="prod"
tenant="oracle"
db_name="Athena"
db_host="athena-oracle-rds.ctspwoqaxc3p.us-east-2.rds.amazonaws.com"
db_pass=""
bk_date=`date +%Y%m%d-%H%M`

bk_file=${db_name}-${tenant}.${bk_date}.bak
s3_path="s3://edulogvn-backup/athena/database/${env}/"

export PGPASSWORD=$db_pass;
cd /tmp
pg_dump -U postgres -h $db_host ${db_name} > $bk_file

aws s3 cp $bk_file $s3_path