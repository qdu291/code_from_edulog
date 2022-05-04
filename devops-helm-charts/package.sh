#!/bin/sh
services="aggregateservice edtaservice gateway geocalculationservice geocodeservice importingservice ivinservice overlayservice plannedrolloverservice reportservice routingmigration routingservice rresservice tnxhubservice specialneeds geoserverservice"

for service in $services; do
echo $service
helm package $service -d athena/charts/
# cp gateway/templates/hpa.yaml $service/templates/
# cp gateway/templates/deployment.yaml $service/templates/
# rm -f $service/templates/deployment.yaml-bak
# helm lint $service
done
