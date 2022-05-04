#!/bin/bash

# VARIABLES #
BASE_DIR="/opt/athena/versions"

# EXECUTE #
cd $BASE_DIR
GW_VER=`cat gateway`
TRX_VER=`cat TransactionHUBV2`
RS_VER=`cat RoutingServer`
GEO_VER=`cat GeoCodeService`
RM_VER=`cat RoutingMigration`
EDTA_VER=`cat DriverTimeAndAttendance`
IVIN_VER=`cat IVIN`
PR_VER=`cat PlannedRollover`

SERVICE_VERSIONS="${GW_VER},${TRX_VER},${RS_VER},${GEO_VER},${RM_VER},${EDTA_VER},${IVIN_VER},${PR_VER}"
echo ${SERVICE_VERSIONS}