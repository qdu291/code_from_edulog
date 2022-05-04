#!/bin/bash
if [ -n "$ENV" ] && [ $ENV = "prod" ] && [ -n "$KARROS_GATEWAY" ]; then
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenant.id=${TENANT_ID} \
    -Dtenant.name=${TENANT} \
    -Dserver.port=9091 \
    -Dspring.kafka.consumer.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    -Dkafka.consume-from.tenant-change.topic=tenantSettings-p01usw1prod \
    -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
    -Dspring.datasource.username=${DB_USER} \
    -Dspring.datasource.password=${DB_PASS} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/CommandDistributor.jar
else
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenant.id=${TENANT_ID} \
    -Dtenant.name=${TENANT} \
    -Dserver.port=9091 \
    -Dspring.kafka.consumer.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    -Dkafka.consume-from.tenant-change.topic=tenantSettings-p01usw2demo \
    -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
    -Dspring.datasource.username=${DB_USER} \
    -Dspring.datasource.password=${DB_PASS} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/CommandDistributor.jar
fi

# Wait for service starting in 2 minutes
sleep 120

# Register txnhub & routing with command-distributor
/opt/athena/helpers/register-command-distributor --appName=txnhub --appPort=8090 --tenantId=$TENANT_ID
/opt/athena/helpers/register-command-distributor --appName=routing --appPort=8081 --tenantId=$TENANT_ID
/opt/athena/helpers/register-command-distributor --appName=reporting --appPort=8084 --tenantId=$TENANT_ID
/opt/athena/helpers/register-command-distributor --appName=rollover --appPort=8100 --tenantId=$TENANT_ID