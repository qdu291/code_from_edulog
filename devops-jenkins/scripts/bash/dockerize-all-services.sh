#!/bin/bash

VERSION=$1
S3_ARTIFACTS_PATH='s3://edulog-athena-artifacts/backend/build'
VERSION_PATH='s3://edulog-athena-artifacts/athena/version'
ATHENA_SERVICES='plannedrolloverservice reportservice routingmigration routingservice tnxhubservice'


# ==> DOWNLOAD VERSION FILE FROM S3
aws s3 cp ${VERSION_PATH}/athena_release_version_${VERSION} .
version_File="athena_release_version_${VERSION}"

# ATHENA ECR LOGIN
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 696952606624.dkr.ecr.us-east-2.amazonaws.com

while read line
do
  # READ EACH LINE IN NEW VERSION FILE
  each_Service_Name=${line%:*}
  each_Service_Version=${line#*:}
  # MAPPING SERVICE NAME TO SYSTEMD NAME AND ARTIFACT FOLDER
  case ${each_Service_Name} in
    Athena)
      service_Systemd_Name="athena";;
    AggregateService)
      service_Systemd_Name="aggregateservice";;
    CommandDistributor)
      service_Systemd_Name="command-distributor";;
    DriverTimeAndAttendance)
      service_Systemd_Name="timeattendance";;
    gateway)
      service_Systemd_Name="gateway";;
    GeoCalculation)
      service_Systemd_Name="geocalculation";;
    GeoCodeService)
      service_Systemd_Name="geocodeservice";;
    ImportService)
      service_Systemd_Name="importservice";;
    IVIN)
      service_Systemd_Name="ivin";;
    Overlay)
      service_Systemd_Name="overlay";;
    RideRegistrationETL)
      service_Systemd_Name="rres";;
    SpecialNeeds)
      service_Systemd_Name="specialneeds";;

  esac

  # DEFINE EACH SERVICE DIRECTORY
  each_service_Dockerize_Directory="./dockerize/${service_Systemd_Name}/${each_Service_Version}"
  
  if [ ${service_Systemd_Name} == "athena" ]; then

    # DOWNLOAD AND EXTRACT JAR FILES FROM ATHENA SERVICES
    each_Service_Artifact_Path="${S3_ARTIFACTS_PATH}/${service_Systemd_Name}/${each_Service_Version}.tar.gz"
    aws s3 cp ${each_Service_Artifact_Path} ${each_service_Dockerize_Directory}/athena_services.tar.gz
    tar xf ${each_service_Dockerize_Directory}/athena_services.tar.gz
    echo "==> Build and Dockerize successed for Athena services"  
    
    # ==============================
    # FOR ATHENA SERVICES: plannedrolloverservice, reportservice, routingmigration, routingservice, tnxhubservice
    for each_Athena_Service in ${ATHENA_SERVICES}; do

      case ${each_Athena_Service} in
        plannedrolloverservice)
          jar_FILE="PlannedRollover.jar";;
        reportservice)
          jar_FILE="ReportsServer.jar";;
        routingmigration)
          jar_FILE="RoutingMigration.jar";;
        routingservice)
          jar_FILE="RoutingServer.jar";;
        tnxhubservice)
          jar_FILE="TransactionHUBV2.jar";;
      esac
      
      Retval=0

      # PULL IMAGES FROM ECR
      docker pull 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${each_Service_Version}

      # RETVAL CHECKING
      if [ $? -eq 0 ]; then
        # IMAGE EXIST => TAG FOR NEW VERSION
        echo "===> Download ${each_Athena_Service} image successed"
        docker tag 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${VERSION}
        docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${VERSION}
        echo "==> Dockerize serviced ${each_Athena_Service} successed"
      
      else
        # SHIP EACH SERVICE JAR FILE TO CORRESPONDING DIRECTORY
        mkdir -p ${each_service_Dockerize_Directory}/${each_Athena_Service}
        mv ${each_Service_Version}/${jar_FILE} ${each_service_Dockerize_Directory}/${each_Athena_Service}/${each_Athena_Service}.jar
        cp -f ./athena/dockerfile/${each_Athena_Service}/Dockerfile ${each_service_Dockerize_Directory}/${each_Athena_Service}/
        echo "==> Downloaded & Copy Dockerfile for service ${each_Athena_Service}"
      
        # DOCKERIZE (BUILD, TAGS, PUSH)
        docker build -t athena/${each_Athena_Service}:${each_Service_Version} ${each_service_Dockerize_Directory}/${each_Athena_Service}
        docker tag athena/${each_Athena_Service}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${each_Service_Version}
        docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${each_Service_Version}
        docker tag athena/${each_Athena_Service}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${VERSION}
        docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${each_Athena_Service}:${VERSION}
        echo "==> Dockerize service ${each_Athena_Service} successed"
      fi

    done

  # FOR THE REST OF SERVICES
  else
    each_Service_Artifact_Path="${S3_ARTIFACTS_PATH}/${service_Systemd_Name}/${each_Service_Version}.jar"

    # PULLING IMAGE FROM ECR
    docker pull 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${each_Service_Version}

    # RETVAL CHECKING
    if [ $? -eq 0 ]; then
      # IMAGE EXIST => TAG FOR NEW VERSION
      echo "===> Download ${service_Systemd_Name} image successed"
      docker tag 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${VERSION}
      docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${VERSION}
      echo "==> Dockerize service ${service_Systemd_Name} successed"

    else
      # IMAGE DOESN'T EXIST => BUILD AND TAG FOR NEW VERSION      
      # PREPARE FOR SERVICE DOCKERIZE
      mkdir -p ${each_service_Dockerize_Directory}
      aws s3 cp ${each_Service_Artifact_Path} ${each_service_Dockerize_Directory}/${each_Service_Name}.jar
      cp -f ./athena/dockerfile/${service_Systemd_Name}/Dockerfile ${each_service_Dockerize_Directory}/
      echo "==> Downloaded & Copy Dockerfile for service ${service_Systemd_Name}"

      # DOCKERIZE (BUILD, TAGS, PUSH)
      docker build -t athena/${service_Systemd_Name}:${each_Service_Version} ${each_service_Dockerize_Directory}
      docker tag athena/${service_Systemd_Name}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${each_Service_Version}
      docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${each_Service_Version}
      docker tag athena/${service_Systemd_Name}:${each_Service_Version} 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${VERSION}
      docker push 696952606624.dkr.ecr.us-east-2.amazonaws.com/athena/${service_Systemd_Name}:${VERSION}
      echo "==> Dockerize service ${service_Systemd_Name} successed"
    fi

  fi

done < ${version_File}

# CLEAN UP IMAGES AFTER BUILD
yes 'y' | docker image prune -a
