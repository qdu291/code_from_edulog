#!/bin/bash
sudo java \
  -Dmanagement.context-path=/ \
  -Dmanagement.endpoints.web.base-path=/ \
  -Dmanagement.endpoints.web.exposure.include="*" \
  -jar -XX:+UseG1GC -Xms256m -Xmx1024m /opt/athena/src/gateway.jar
