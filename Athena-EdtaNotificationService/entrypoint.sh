#!/bin/sh
java -Djava.security.egd=file:/dev/./urandom                              \
     -Dcom.sun.management.jmxremote                                       \
     -Dcom.sun.management.jmxremote.authenticate=false                    \
     -Dcom.sun.management.jmxremote.ssl=false                             \
     -Dcom.sun.management.jmxremote.port=9400                             \
     -Dspring.cloud.client.hostname=$HOSTNAME                             \
     -Deureka.instance.hostname=$HOSTNAME                                 \
     -Dspring.profiles.active=$PROFILE                                    \
     -Deureka.instance.preferIpAddress=$PREFERIP                          \
     -Dspring.cloud.inetutils.ignoredInterfaces=ecs-eth0                  \
     -DLOG_PATH=/opt/karros_tech/logs                                     \
     -DLOG_FILE=/opt/karros_tech/logs/athenanotification.log              \
     -Dmanagement.security.enabled=false                                  \
     -Deureka.datacenter=cloud                                            \
     -Dmanagement.context-path=/                                          \
     -jar -Xms256m -Xmx1024m /home/karros/app.jar