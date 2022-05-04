#!/bin/bash
#Get Parameters from ConfigMap
siteList="vb-eks"
action="stop"
# List out Sites
IFS="," read -r -a arrList <<< "$siteList"

# Determine start/stop action
if [ "$action" == "stop" ]; then
  rep_no=0
else
  rep_no=1
fi

#Scale services
echo "My array: ${arrList[@]}"
echo "Number of elements in the array: ${#arrList[@]}"

for element in "${arrList[@]}"
do
  echo "Site: $element"
  echo "Action: $action"
  kubectl scale deploy -l scheduling=vn --replicas=$rep_no -n $element
done