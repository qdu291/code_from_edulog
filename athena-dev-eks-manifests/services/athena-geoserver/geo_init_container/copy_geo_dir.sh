#!/bin/bash

DIR="$1"
# init
# look for empty dira
if [ -d "$DIR/workspaces" ]
then
# 	if [ "$(ls -A $DIR/workspace)" ]; then
  echo "Geo data already exist"
	# else
  #   echo "Geo Data is empty. Copying base data"
  #   cp -r /opt/geoserver/data_dir/* $DIR
	# fi
else
	echo "Directory $DIR/workspace not found."
  cp -r /opt/geoserver/data_dir/* $DIR
  retcode=$?
  echo $retcode
  if [ $retcode -eq 0 ]; then
      echo "Geoserver Data have been copied to GEOSERVER_DATA_DIR location"
  else
    echo "Geoserver Data could not be copied. Please check"
  fi
fi