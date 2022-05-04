#!/bin/bash
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  --spring.config.location=file:///opt/athena/config/pp-integration/application.properties \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/ParentPortalIntegrationBatch.jar
