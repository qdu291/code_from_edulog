#!/bin/bash
dbHost=$1
siteName=$2
envtype=$3

dbPass='edul0g'
s3path="edulog-athena-prod-artifacts/athena/exporting/exportfiles/${siteName}"

if [ $envtype = 'nonprod' ]; then
  s3path="edulog-athena-artifacts/athena/exportfiles/nonprod/${siteName}"
fi

PGPASSWORD=${dbPass} psql -h ${dbHost} -p 5432 -d Athena -U edulog << EOF
UPDATE geo_plan.config
SET value='${s3path}', description='${siteName}'
WHERE setting like 'S3_BUCKET';
select * from geo_plan.config;
EOF