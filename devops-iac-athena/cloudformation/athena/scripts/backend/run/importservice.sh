#!/bin/bash
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/ImportService.jar \
  --spring.data.mongodb.host=${CACHE_HOST} \
  --karros.athenagateway=${KARROS_GATEWAY} \
  --karros.keycloak.clientid=${KEYCLOAK_BACKEND_ID} \
  --karros.keycloak.clientsecret=${KEYCLOAK_SECRET} \
  --karros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
  --karros.keycloak.logouturl=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/logout \
  --karros.keycloak.forgotpasswordurl=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/karros-auth/forgot-password \
  --athena.tenant.id=${TENANT_ID}