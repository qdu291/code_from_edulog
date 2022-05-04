FROM adoptopenjdk/openjdk11:alpine-slim

ENV GEOSERVER_HOME=/opt/geoserver
#ENV GEOSERVER_DATA_DIR=/geo_data
COPY ./copy_geo_dir.sh /opt/geoserver/copy_geo_dir.sh

RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates

RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/2.18.2/geoserver-2.18.2-bin.zip

# RUN mkdir /geodata

# RUN mkdir /opt/geoserver
RUN unzip -q /tmp/geoserver.zip -d /opt/geoserver

# RUN sh /opt/geoserver/copy_geo_dir.sh

# RUN cp -r /opt/geoserver/data_dir/* /geo-data/

RUN sed -i -r "s/jetty.port=8080/jetty.port=8070/g" /opt/geoserver/start.ini

# Add bounding box to each exported feature by WFS service
RUN sed -i -r "s/<featureBounding>.*<\/featureBounding>/<featureBounding>true<\/featureBounding>/g"  /opt/geoserver/data_dir/wfs.xml

# EXPOSE 8070

# CMD /opt/geoserver/bin/startup.sh