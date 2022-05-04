#!/bin/bash
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
  -Dspring.data.mongodb.host=${CACHE_HOST} \
  -Dkarros.keycloak.clientid=${KEYCLOAK_BACKEND_ID} \
  -Dkarros.keycloak.clientsecret=${KEYCLOAK_SECRET} \
  -Dkarros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
  -Dathena.tenant.id=${TENANT_ID} \
  -Dkarros.general.url=https://${KARROS_GATEWAY} \
  -Dvms.api.url=https://${KARROS_GATEWAY}/api \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/ReportsServer.jar