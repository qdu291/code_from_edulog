#!/bin/bash
sudo java \
  -Dcom.sun.management.jmxremote.port=6001 \
  -Dcom.sun.management.jmxremote=true \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.rmi.port=6001 \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -jar -XX:+UseG1GC -Xms256m -Xmx4096m /opt/athena/src/GeoCodeService.jar \
  --spring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
  --athena.multi-tenant.enabled=false