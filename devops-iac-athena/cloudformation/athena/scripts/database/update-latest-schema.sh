DB_HOST="athena-demoleg-rds.ctspwoqaxc3p.us-east-2.rds.amazonaws.com"
DB_NAME="Athena"
sudo java -Ddb.server=${DB_HOST} -Ddb.name=${DB_NAME} \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/RoutingMigration.jar