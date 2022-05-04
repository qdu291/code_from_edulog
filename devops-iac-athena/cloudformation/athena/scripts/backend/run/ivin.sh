#!/bin/bash
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -Dspring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/Athena \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/IVIN.jar
