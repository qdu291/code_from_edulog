#!/bin/bash
if [ -n "$ENV" ] && [ $ENV = "prod" ] && [ -n "$KARROS_GATEWAY" ]; then
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenantconfig.api.url=https://${KARROS_GATEWAY}/api/ \
    -Dkarros.api.key=9d6c3f85669a40cd1b1fa4635b049b92bb04c881 \
    -Dkarros.keycloak.clientid=${KEYCLOAK_BACKEND_ID} \
    -Dkarros.keycloak.clientsecret=${KEYCLOAK_SECRET} \
    -Dkarros.keycloak.url=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/token \
    -Dkarros.keycloak.logouturl=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/protocol/openid-connect/logout \
    -Dkarros.keycloak.forgotpasswordurl=https://${KEYCLOAK_DOMAIN}/auth/realms/Edulog/karros-auth/forgot-password \
    -Dathena.tenant.id=${TENANT_ID} \
    -Dkarros.general.url=https://${KARROS_GATEWAY} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/PlannedRollover.jar
else
  sudo java \
    -Dmanagement.context-path=/ \
    -Dmanagement.endpoints.web.base-path=/ \
    -Dmanagement.endpoints.web.exposure.include="*" \
    -Dtenantconfig.api.url=https://athenagateway-p01-demo.usw2.karrostech.net/api/ \
    -Dkarros.api.key=9d6c3f85669a40cd1b1fa4635b049b92bb04c881 \
    -Dathena.tenant.id=${TENANT_ID} \
    -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/PlannedRollover.jar
fi