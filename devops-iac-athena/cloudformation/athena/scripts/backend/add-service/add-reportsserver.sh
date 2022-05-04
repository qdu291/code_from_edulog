#!/bin/bash -xe

# Script add new service

# Variables
env="dev"
service_name="reportsserver"
source_name="ReportsServer"
bucket="edulogvn-artifacts"
prefix="athena/backend/${source_name}/${env}"
rds_endpoint="athena-redlake-rds.ctspwoqaxc3p.us-east-2.rds.amazonaws.com"

# Go working dir
cd /opt/athena

# Add env file
cat << EOF > env/${service_name}.env
DB_HOST=${rds_endpoint}
DB_USER=edulog
DB_PASS=edul0g
EOF


# Add resources dir if need
mkdir -p resources/report

# Add run script
cat << EOF > run/${service_name}.sh
#!/bin/bash
sudo java \\
  -Dspring.datasource.url=jdbc:postgresql://\${DB_HOST}:5432/Athena \\
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/${source_name}.jar
EOF
chmod +x run/${service_name}.sh

# Add service
cat << EOF > service/${service_name}.service
[Unit]
Description=Athena ${source_name} Service
After=network.target

[Service]
ExecStartPre=/bin/sleep 5
Type=simple
EnvironmentFile=/opt/athena/env/${service_name}.env
ExecStart=/opt/athena/run/${service_name}.sh
User=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo cp service/${service_name}.service /etc/systemd/system/

# Add jar file
aws s3 cp s3://${bucket}/${prefix}/${source_name}.jar ./src/

# Start service
sudo systemctl start ${service_name}
sudo systemctl enable ${service_name}


# Show service log
journalctl -f _SYSTEMD_UNIT=${service_name}.service
