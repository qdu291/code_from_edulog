#!/bin/bash

# Check variables
if [ $# -ne 2 ]; then
  echo "Usage: restore-db db_host postgres_pass"
  exit 1
fi


db_host=$1
postgres_pass=$2
db_name="Athena"
user="edulog"
schema=""

export PGPASSWORD=$postgres_pass
# Update previleges for user in DB
psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA settings TO "${user}"";

# Update owner for Athena Schemas
# geo_plan | public | rp_master | rp_plan | settings
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
