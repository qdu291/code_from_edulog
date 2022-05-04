#!/bin/bash

# user=$1 
# pass=$2 # User postgres password
user="edulog"
pass="edul0g" # User postgres password
db_name="Athena"
git_repo="https://github.com/tankhuu121/Athena-Build-Provision.git"


echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt update

# install PostgreSQL
echo "Installing PostgreSQL"
apt install -y postgresql-12 postgis postgresql-contrib

# Allow remote connection into db
echo "Setting up PostgreSQL"
sudo -u postgres psql -c "alter user postgres with password $pass"
echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/12/main/pg_hba.conf

systemctl restart postgresql
systemctl enable postgresql

sudo -u postgres psql -c "CREATE USER $user; ALTER USER $user WITH PASSWORD '$pass';"
sudo -u postgres psql -c "CREATE DATABASE \""${db_name}"\";"
sudo -u postgres psql -d $db_name -c "CREATE EXTENSION postgis";

# Import base data
cd ~
git clone $git_repo
cd Athena-Build-Provision/instance-provisioning/db/localdev/sql
sudo -u postgres psql -d ${db_name} -f "${db_name}_backup.sql"
sudo -u postgres psql -d ${db_name} -f "vehicles.sql"

echo "Granting privileges."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE \""${db_name}"\" to "${user}"";
sudo -u postgres psql -d ${db_name} -c "GRANT USAGE ON SCHEMA public TO "${user}"";
sudo -u postgres psql -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA public TO "${user}"";
sudo -u postgres psql -d ${db_name}  -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "${user}"";
sudo -u postgres psql -d ${db_name}  -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "${user}"";
sudo -u postgres psql -d ${db_name} -c "GRANT USAGE ON SCHEMA settings TO "${user}"";
sudo -u postgres psql -d ${db_name} -c "GRANT ALL PRIVILEGES ON SCHEMA settings TO "${user}"";
sudo -u postgres psql -d ${db_name}  -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA settings TO "${user}"";
sudo -u postgres psql -d ${db_name}  -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA settings TO "${user}"";

# Setup user profile
sudo -u postgres psql -d ${db_name} -f "setup_default_users_and_profiles.sql"
