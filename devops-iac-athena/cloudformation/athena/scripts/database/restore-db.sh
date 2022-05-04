#!/bin/bash

# Check variables
if [ $# -ne 4 ]; then
  echo "Usage: restore-db env db_host postgres_pass backup_file"
  exit 1
fi

env=$1
db_host=$2
postgres_pass=$3
backup_file=$4
db_name="Athena"
user="edulog"
schema=""
s3_path="s3://edulogvn-backup/athena/database/$env/$backup_file"

cd /tmp
aws s3 cp $s3_path .

export PGPASSWORD=$postgres_pass
psql -U postgres -h $db_host -d "Athena" -f $backup_file

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
rm -f $backup_file
