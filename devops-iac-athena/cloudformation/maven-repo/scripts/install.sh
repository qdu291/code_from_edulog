#!/bin/bash
sudo apt-get update
sudo apt-get install openjdk-8-jre openjdk-8-jdk -y
sudo update-alternatives --config java
sudo update-alternatives --config javac
java -version

sudo useradd archivasvc -s /bin/bash -M
sudo mkdir -p /var/log/archiva
sudo chown archivasvc:adm /var/log/archiva
sudo chmod 755 /var/log/archiva
sudo ufw allow 8080/tcp

wget https://mirror.downloadvn.com/apache/archiva/2.2.4/binaries/apache-archiva-2.2.4-bin.tar.gz
tar zxvf apache-archiva-2.2.4-bin.tar.gz
cd apache-archiva-2.2.4/
vi bin/archiva
vi conf/wrapper.conf
vi conf/jetty.xml
vi apps/archiva/WEB-INF/classes/log4j2.xml
cd ..
sudo chown -R archivasvc:archivasvc apache-archiva-2.2.4
cd apache-archiva-2.2.4/
sudo ln -s `pwd`/bin/archiva /etc/init.d/archiva
sudo update-rc.d archiva defaults 80

sudo systemctl start archiva.service
sudo systemctl status archiva.service
journalctl -u archiva.service

sudo systemctl enable archiva.service

grep "initServers" /var/log/archiva/archiva.log
sudo netstat -tlnp | grep "LISTEN " | grep 8080

grep "initServers" /var/log/archiva/archiva.log
sudo systemctl restart archiva.service

tail -f /var/log/archiva/archiva.log