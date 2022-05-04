#!/bin/bash -xe

# This script is used to transfer data from source to destination

## Variables
run_date=`date +%Y%m%d-%H%M`
pg_master_user="postgres"
### Source
s_tenant_name="stage"
s_db_name="Athena"
s_db_host=""
s_db_pass=""
s_file_name="${s_db_name}.${s_tenant_name}.${run_date}.bak"
### Destination
s_tenant_name="stage"
d_db_name="Athena"
d_db_host=""
d_db_pass=""
d_db_user="edulog"
schema=""

## Main
### Go to working dir
cd /tmp

### Backup Source Data
echo "=> Backup Data from Source"
export PGPASSWORD=$s_db_pass;
pg_dump -U $pg_master_user -h $s_db_host $s_db_name > $s_file_name

### Restore Data to Destination
export PGPASSWORD=$d_db_pass
### Recreate Database in Destination
echo "=> Terminate all connections in DB"
psql -U postgres -h $db_host -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${db_name}';"
echo "=> Drop Database on Dest"
psql -U $pg_master_user -h $d_db_host -c "DROP DATABASE \"${d_db_name}\";"

echo "=> Recreate Database on Dest"
psql -U $pg_master_user -h $d_db_host -c "CREATE DATABASE \"${d_db_name}\";" 
psql -U $pg_master_user -h $d_db_host -c "CREATE EXTENSION postgis;" $d_db_name
echo "=> Restore data on Dest"
psql -U $pg_master_user -h $d_db_host -d $d_db_name -f $s_file_name

echo "=> Update Schema on Dest"
# geo_plan | public | rp_master | rp_plan | settings
schema="geo_plan"
for table in `psql -U $pg_master_user -h $d_db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${d_db_name}` ; do  psql -U $pg_master_user -h $d_db_host -c "alter table ${schema}.${table} owner to ${d_db_user}" ${d_db_name} ; done

schema="public"
for table in `psql -U $pg_master_user -h $d_db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${d_db_name}` ; do  psql -U $pg_master_user -h $d_db_host -c "alter table ${schema}.${table} owner to ${d_db_user}" ${d_db_name} ; done

schema="rp_master"
for table in `psql -U $pg_master_user -h $d_db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${d_db_name}` ; do  psql -U $pg_master_user -h $d_db_host -c "alter table ${schema}.${table} owner to ${d_db_user}" ${d_db_name} ; done

schema="rp_plan"
for table in `psql -U $pg_master_user -h $d_db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${d_db_name}` ; do  psql -U $pg_master_user -h $d_db_host -c "alter table ${schema}.${table} owner to ${d_db_user}" ${d_db_name} ; done

schema="settings"
for table in `psql -U $pg_master_user -h $d_db_host -tc "select tablename from pg_tables where schemaname = '${schema}';" ${d_db_name}` ; do  psql -U $pg_master_user -h $d_db_host -c "alter table ${schema}.${table} owner to ${d_db_user}" ${d_db_name} ; done

## Outputs
