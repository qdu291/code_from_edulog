#!/bin/bash
if [ -n "$ENV" ] && [ $ENV = "prod" ] && [ -n "$KARROS_GATEWAY" ]; then
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
    -Dspring.rabbitmq.host=${QUEUE_HOST} \
    -Dspring.rabbitmq.username=${QUEUE_USER} \
    -Dspring.rabbitmq.password=${QUEUE_PASS} \
    -Dspring.data.mongodb.host=${CACHE_HOST} \
    -Ddebezium_controller.api.url=${DEBEZIUM_CONTROLLER_API} \
    -Ddebezium_controller.api.key=${DEBEZIUM_CONTROLLER_KEY} \
    -Ddebezium_controller.service_name=${TENANT} \
    -Dathena.env.name=${ENV} \
    -Dathena.tenant.id=${TENANT_ID} \
    -Drouting-service.es.url=${ES_URL} \
    -Drouting-service.es.username=${ES_USERNAME} \
    -Drouting-service.es.password=${ES_PASSWORD} \
    -Drouting-service.es.protocol=${ES_PROTOCOL} \
    -Drouting-service.es.connectionTimeout=${ES_CONNECTIONTIMEOUT} \
    -Drouting-service.es.socketTimeout=${ES_SOCKETTIMEOUT} \
    -Drouting-service.es.parallelESCountThreads=${ES_PARALELLESTHREADCOUNT} \
    -Drouting-service.es.port=${ES_PORT} \
    -Drouting-service.es.run.index=${ES_RUN_INDEX} \
    -Drouting-service.es.route.index=${ES_ROUTE_INDEX} \
    -Drouting-service.es.trip.index=${ES_TRIP_INDEX} \
    -Drouting-service.es.snapshot.write.enabled=${ES_SNAPSHOT_ENABLED} \
    -Drouting-service.es.snapshot.write.suppress.errors=${ES_SNAPSHOT_SUPRESS_WRITE_ERRORS} \
    -Drouting-service.es.snapshot.sync.enabled=${ES_SNAPSHOT_ROUTING_WRITE_ENABLED} \
    -Dkarros.general.url="https://${KARROS_GATEWAY}" \
    -Dnos.api.url=http://${NOS_HOST}:8901/liveNOS \
    -Dkarros.keycloak.clientid=${KEYCLOAK_BACKEND_ID} \
    -Dkarros.keycloak.clientsecret=${KEYCLOAK_SECRET} \
    -Dkarros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
    -jar -XX:+UseG1GC -Xms256m -Xmx4096m /opt/athena/src/RoutingServer.jar
else
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
    -Dspring.rabbitmq.host=${QUEUE_HOST} \
    -Dspring.rabbitmq.username=${QUEUE_USER} \
    -Dspring.rabbitmq.password=${QUEUE_PASS} \
    -Dspring.data.mongodb.host=${CACHE_HOST} \
    -Ddebezium_controller.api.url=${DEBEZIUM_CONTROLLER_API} \
    -Ddebezium_controller.api.key=${DEBEZIUM_CONTROLLER_KEY} \
    -Ddebezium_controller.service_name=${TENANT} \
    -Dathena.env.name=stage \
    -Dathena.tenant.id=${TENANT_ID} \
    -Drouting-service.es.url=${ES_URL} \
    -Drouting-service.es.username=${ES_USERNAME} \
    -Drouting-service.es.password=${ES_PASSWORD} \
    -Drouting-service.es.protocol=${ES_PROTOCOL} \
    -Drouting-service.es.connectionTimeout=${ES_CONNECTIONTIMEOUT} \
    -Drouting-service.es.socketTimeout=${ES_SOCKETTIMEOUT} \
    -Drouting-service.es.parallelESCountThreads=${ES_PARALELLESTHREADCOUNT} \
    -Drouting-service.es.port=${ES_PORT} \
    -Drouting-service.es.run.index=${ES_RUN_INDEX} \
    -Drouting-service.es.route.index=${ES_ROUTE_INDEX} \
    -Drouting-service.es.trip.index=${ES_TRIP_INDEX} \
    -Drouting-service.es.snapshot.write.enabled=${ES_SNAPSHOT_ENABLED} \
    -Drouting-service.es.snapshot.write.suppress.errors=${ES_SNAPSHOT_SUPRESS_WRITE_ERRORS} \
    -Drouting-service.es.snapshot.sync.enabled=${ES_SNAPSHOT_ROUTING_WRITE_ENABLED} \
    -Dnos.api.url=http://${NOS_HOST}:8901/liveNOS \
    -jar -XX:+UseG1GC -Xms256m -Xmx4096m /opt/athena/src/RoutingServer.jar
fi
