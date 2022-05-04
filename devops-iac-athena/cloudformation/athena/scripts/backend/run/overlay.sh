#!/bin/bash
SERVICE_NAME=Overlay
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -jar -XX:+UseG1GC -Xms256m -Xmx1g /opt/athena/src/${SERVICE_NAME}.jar \
  --overlay.database.server=${DB_HOST} \
  --geocode.database.server=${DB_HOST}