FROM openjdk:8-jdk-alpine
ARG BUILD_VERSION
RUN mkdir -p /opt/karrostech/logs && mkdir -p /home/karros
ADD target/AthenaEdtaNotification-${BUILD_VERSION}.jar /home/karros/app.jar
ADD entrypoint.sh /home/karros/entrypoint.sh
RUN chmod +x /home/karros/entrypoint.sh
EXPOSE 9400
ENTRYPOINT ["/home/karros/entrypoint.sh"]