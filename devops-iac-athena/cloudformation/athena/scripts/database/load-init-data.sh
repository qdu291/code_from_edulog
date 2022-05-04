#!/bin/bash

#demo-Athena-20200415-1528.bak
#demo-Athena-20200418-0904.bak

db_host=$1
init_data_file=$2


# Create user and database
psql -U postgres -h $db_host
###############################
CREATE USER edulog; ALTER USER edulog WITH PASSWORD 'edul0g';
CREATE DATABASE "Athena";
\c Athena
CREATE EXTENSION postgis;


user="edulog"
db_name="Athena"
schema=""
s3_path="s3://edulogvn-backup/athena/database/demo/demo-Athena-20200415-1528.bak"

# Load data into database
cd /tmp
aws s3 cp $s3_path .

psql -U postgres -h $db_host -d "Athena" -f $init_data_file
rm -f $init_data_file

# Update previleges for user in DB
GRANT ALL PRIVILEGES ON DATABASE "Athena" to edulog;
GRANT USAGE ON SCHEMA public TO edulog;
GRANT ALL PRIVILEGES ON SCHEMA public TO edulog;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO edulog;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO edulog;
GRANT USAGE ON SCHEMA settings TO edulog;
GRANT ALL PRIVILEGES ON SCHEMA settings TO edulog;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA settings TO edulog;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA settings TO edulog;

# Update owner for Athena Schemas
# geo_plan | public | rp_master | rp_plan | settings

user="edulog"
db_name="Athena"
db_host="edulogvn-athena-prod-hall.ctspwoqaxc3p.us-east-2.rds.amazonaws.com"
export PGPASSWORD='Cl9a1iDRnDwI';

schema="geo_plan"
for table in `psql -U postgres -h $db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${db_name}` ; do  psql -U postgres -h $db_host -c "alter table ${schema}.${table} owner to ${user}" ${db_name} ; done

schema="public"
for table in `psql -U postgres -h $db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${db_name}` ; do  psql -U postgres -h $db_host -c "alter table ${schema}.${table} owner to ${user}" ${db_name} ; done

schema="rp_master"
for table in `psql -U postgres -h $db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${db_name}` ; do  psql -U postgres -h $db_host -c "alter table ${schema}.${table} owner to ${user}" ${db_name} ; done

schema="rp_plan"
for table in `psql -U postgres -h $db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${db_name}` ; do  psql -U postgres -h $db_host -c "alter table ${schema}.${table} owner to ${user}" ${db_name} ; done

schema="settings"
for table in `psql -U postgres -h $db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${db_name}` ; do  psql -U postgres -h $db_host -c "alter table ${schema}.${table} owner to ${user}" ${db_name} ; done

