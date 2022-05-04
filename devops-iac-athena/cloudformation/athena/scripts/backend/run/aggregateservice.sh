#!/bin/bash
if [ -n "$ENV" ] && [ $ENV = "prod" ]; then
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenant.id=${TENANT_ID} \
    -Dtenant.name=${TENANT} \
    -Dspring.kafka.consumer.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    -Dspring.kafka.producer.bootstrap-servers=${ATHENA_KAFKA_PRODUCERS} \
    -Dspring.kafka.producer.topic.athenaSchoolChange=athenaSchoolChange-p01usw1prod \
    -Dspring.kafka.producer.topic.athenaStudentChange=athenaStudentChange-p01usw1prod \
    -Dspring.kafka.producer.topic.athenaTransportRequestChange=athenaTransportationRequestChange-p01usw1prod \
    -Dagg-service.es.url=${ES_URL} \
    -Dagg-service.es.username=${ES_USERNAME} \
    -Dagg-service.es.password=${ES_PASSWORD} \
    -Dagg-service.es.port=${ES_PORT} \
    -Dagg-service.es.run.index=${ES_RUN_INDEX} \
    -Dagg-service.es.trip.index=${ES_TRIP_INDEX} \
    -Dagg-service.es.snapshot.write.enabled=${ES_SNAPSHOT_ENABLED} \
    -Dagg-service.es.snapshot.sync.disabled=${ES_SNAPSHOT_ROUTING_WRITE_ENABLED} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/AggregateService.jar
else
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenant.id=${TENANT_ID} \
    -Dtenant.name=${TENANT} \
    -Dspring.kafka.consumer.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    -Dspring.kafka.producer.bootstrap-servers=${ATHENA_KAFKA_PRODUCERS} \
    -Dagg-service.es.url=${ES_URL} \
    -Dagg-service.es.username=${ES_USERNAME} \
    -Dagg-service.es.password=${ES_PASSWORD} \
    -Dagg-service.es.port=${ES_PORT} \
    -Dagg-service.es.run.index=${ES_RUN_INDEX} \
    -Dagg-service.es.trip.index=${ES_TRIP_INDEX} \
    -Dagg-service.es.snapshot.write.enabled=${ES_SNAPSHOT_ENABLED} \
    -Dagg-service.es.snapshot.sync.disabled=${ES_SNAPSHOT_ROUTING_WRITE_ENABLED} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/AggregateService.jar
fi
