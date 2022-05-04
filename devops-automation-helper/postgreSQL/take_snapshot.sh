#!/bin/bash -ex

env=$1
tenant=$2
db_host=$3
db_pass=$4
s3_bucket=$5
db_name="Athena"
bk_date=`date +%Y%m%d-%H%M`

bk_file=${db_name}-${tenant}.${bk_date}.bak
s3_path="s3://${s3_bucket}/athena/database/${env}/${tenant}/"

export PGPASSWORD=$db_pass;
cd /tmp
pg_dump -U postgres -h $db_host ${db_name} > $bk_file

aws s3 cp $bk_file $s3_path