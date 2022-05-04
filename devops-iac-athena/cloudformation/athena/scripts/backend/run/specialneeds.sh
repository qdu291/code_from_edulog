#!/bin/bash
SERVICE_NAME=SpecialNeeds
sudo java \
  -jar -XX:+UseG1GC -Xms256m -Xmx1g /opt/athena/src/${SERVICE_NAME}.jar \
  --special-need.database.server=${DB_HOST}