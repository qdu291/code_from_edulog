#!/bin/bash

# Check variables
if [ $# -ne 2 ]; then
  echo "Usage: init-data db_host postgres_pass"
  exit 1
fi

db_host=$1
postgres_pass=$2
db_name="Athena"
user="edulog"
schema=""
s3_path="s3://edulogvn-devops/athena/database/base"
base_schema="Athena_Blank.sql"
geo_settings="geocode_settings.sql"

cd /tmp
aws s3 cp $s3_path/$base_schema .
aws s3 cp $s3_path/$geo_settings .

export PGPASSWORD=$postgres_pass
psql -U postgres -h $db_host -d "Athena" -f $base_schema
psql -U postgres -h $db_host -d "Athena" -f $geo_settings

# Update previleges for user in DB
psql -U postgres -h $db_host -c "GRANT ALL PRIVILEGES ON DATABASE \""${db_name}"\" to "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA geo_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA geo_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA geo_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA geo_master TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA settings TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA settings TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA edta TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA edta TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA edta TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA edta TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA rp_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA rp_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA rp_master TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA rp_master TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA ivin TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA ivin TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ivin TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ivin TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA geo_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA geo_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA geo_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA geo_plan TO "${user}"";

psql -U postgres -h $db_host -d ${db_name} -c "GRANT USAGE ON SCHEMA rp_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA rp_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA rp_plan TO "${user}"";
psql -U postgres -h $db_host -d ${db_name} -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA rp_plan TO "${user}"";

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

# Cleanup
rm -f $base_schema
rm -f $geo_settings
