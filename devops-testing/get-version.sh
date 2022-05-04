#!/bin/bash
VERSION=$1
S3_VERSION_PATH='s3://edulog-athena-artifacts/athena/version'
VER_DIR="/opt/athena/versions"

# ==> GET CURRENT VERSION INFO
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

mkdir /tmp/deploy

echo "Athena:${Athena_Version}" > /tmp/deploy/athena_release_version_$1
echo "AggregateService:${AggregateService_Version}" >> /tmp/deploy/athena_release_version_$1
echo "CommandDistributor:${CommandDistributor_Version}" >> /tmp/deploy/athena_release_version_$1
echo "DriverTimeAndAttendance:${DriverTimeAndAttendance_Version}" >> /tmp/deploy/athena_release_version_$1
echo "gateway:${gateway_Version}" >> /tmp/deploy/athena_release_version_$1
echo "GeoCalculation:${GeoCalculation_Version}" >> /tmp/deploy/athena_release_version_$1
echo "GeoCodeService:${GeoCodeService_Version}" >> /tmp/deploy/athena_release_version_$1
echo "ImportService:${ImportService_Version}" >> /tmp/deploy/athena_release_version_$1
echo "IVIN:${IVIN_Version}" >> /tmp/deploy/athena_release_version_$1
echo "Overlay:${Overlay_Version}" >> /tmp/deploy/athena_release_version_$1
echo "RideRegistrationETL:${RideRegistrationETL_Version}" >> /tmp/deploy/athena_release_version_$1
echo "SpecialNeeds:${SpecialNeeds_Version}" >> /tmp/deploy/athena_release_version_$1

# UPLOAD VERSION FILE TO S3

aws s3 cp /tmp/deploy/athena_release_version_$1 ${S3_VERSION_PATH}/


