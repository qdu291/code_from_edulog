#!/bin/bash -xe

# CHECK PARAMS #
if [ $# -ne 1 ]; then
  echo $0: Usage: service_name
  exit 1
fi

# VARIABLES #
SERVICE_NAME=$1

# EXECUTE #
case $SERVICE_NAME in 
  gateway)
    echo "==> Restarting gateway"
    sudo systemctl restart gateway
    ;;
  TransactionHUBV2)
    echo "==> Restarting middle"
    sudo systemctl restart middle
    ;;
  RoutingServer)
    echo "==> Restarting backend"
    sudo systemctl restart backend
    ;;
  GeoCodeService)
    echo "==> Restarting geocodeservice"
    sudo systemctl restart geocodeservice
    ;;
  DriverTimeAndAttendance)
    echo "==> Restarting timeattendance"
    sudo systemctl restart timeattendance
    ;;
  IVIN)
    echo "==> Restarting ivin"
    sudo systemctl restart ivin
    ;;
  PlannedRollover)
    echo "==> Restarting plannedrollover"
    sudo systemctl restart plannedrollover
    ;;
  *)
    echo "Nothing to apply"
    ;;
esac
