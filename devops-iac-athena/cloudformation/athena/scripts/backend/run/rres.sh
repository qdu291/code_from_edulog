#!/bin/bash
if [ -n "$ENV" ] && [ $ENV = "prod" ]; then
  sudo java -Dspring.profiles.active=prod \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/RideRegistrationETL.jar \
    --kafka.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    --kafka.consumer.group-id=${TENANT}-rideRegistrationRequest \
    --kafka.consumer.topics=${TENANT_ID}-athenaRideRegistrationChange-p01usw1prod \
    --mongo.url=mongodb://${CACHE_HOST}:27017/?uuidRepresentation=STANDARD \
    --application.athena.tenant.id=${TENANT_ID} \
    --application.athena.root=http://localhost:8090/api/v1 \
    --application.karros.login.url=https://${KARROS_GATEWAY}/api/v1/signin \
    --application.karros.keycloak.client-id=${KEYCLOAK_BACKEND_ID} \
    --application.karros.keycloak.client-secret=${KEYCLOAK_SECRET} \
    --application.karros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
    --application.karros.keycloak.logout-url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/logout \
    --application.karros.keycloak.forgot-password-url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/karros-auth/forgot-password
else
  sudo java -Dspring.profiles.active=prod \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/RideRegistrationETL.jar \
    --kafka.bootstrap-servers=${ATHENA_KAFKA_CONSUMERS} \
    --kafka.consumer.group-id=${TENANT}-rideRegistrationRequest \
    --kafka.consumer.topics=${TENANT_ID}-athenaRideRegistrationChange-usw2demo \
    --mongo.url=mongodb://${CACHE_HOST}:27017/?uuidRepresentation=STANDARD \
    --application.athena.tenant.id=${TENANT_ID} \
    --application.athena.root=http://localhost:8090/api/v1 \
    --application.karros.login.url=https://${KARROS_GATEWAY}/api/v1/signin \
    --application.karros.keycloak.client-id=${KEYCLOAK_BACKEND_ID} \
    --application.karros.keycloak.client-secret=${KEYCLOAK_SECRET} \
    --application.karros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
    --application.karros.keycloak.logout-url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/logout \
    --application.karros.keycloak.forgot-password-url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/karros-auth/forgot-password
fi