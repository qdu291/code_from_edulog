#!/bin/bash
S3_VERSION_PATH='s3://edulog-athena-artifacts/athena/version'
VER_DIR="/opt/athena/versions"
ATHENA_SERVICES='Athena AggregateService CommandDistributor DriverTimeAndAttendance gateway GeoCalculation GeoCodeService ImportService IVIN Overlay RideRegistrationETL SpecialNeeds'

# CHECK VERSION INPUT NOT NULL
if [ ! -z $1 ]; then
  VERSION=$1
else
  echo 'Missing the version variable, Please check the version as $1'
  exit 0
fi

# GET CURRENT VERSION INFO
Athena_Version=$(<${VER_DIR}/Athena)
AggregateService_Version=$(<${VER_DIR}/AggregateService)
CommandDistributor_Version=$(<${VER_DIR}/CommandDistributor)
DriverTimeAndAttendance_Version=$(<${VER_DIR}/DriverTimeAndAttendance)
gateway_Version=$(<${VER_DIR}/gateway)
GeoCalculation_Version=$(<${VER_DIR}/GeoCalculation)
GeoCodeService_Version=$(<${VER_DIR}/GeoCodeService)
ImportService_Version=$(<${VER_DIR}/ImportService)
IVIN_Version=$(<${VER_DIR}/IVIN)
Overlay_Version=$(<${VER_DIR}/Overlay)
RideRegistrationETL_Version=$(<${VER_DIR}/RideRegistrationETL)
SpecialNeeds_Version=$(<${VER_DIR}/SpecialNeeds)

mkdir -p /tmp/deploy
rm -f /tmp/deploy/athena_release_version_${VERSION}

for each_Service in ${ATHENA_SERVICES}; do
  each_Service_Version=${each_Service}_Version
  each_Version_Length=${!each_Service_Version}

  if [ ! -z ${!each_Service_Version} ] && [ ${#each_Version_Length} == 40 ]; then
    echo "==> ${each_Service} version: ${!each_Service_Version}"
    echo "${each_Service}:${!each_Service_Version}" >> /tmp/deploy/athena_release_version_${VERSION}
  else
    echo "==> There is an error with service ${each_Service}"
    echo "The script will be exited"
    exit 0
  fi
done

# UPLOAD VERSION FILE TO S3
aws s3 cp /tmp/deploy/athena_release_version_${VERSION} ${S3_VERSION_PATH}/