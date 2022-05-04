#!/bin/bash

systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
systemctl mask apt-daily.service
systemctl daemon-reload

sudo apt update
sudo apt install -y npm
sudo npm install -g npm
sudo npm install -g n
sudo npm cache clean

sudo n 12.15.0

git clone https://github.com/tankhuu121/EduLog-AthenaUI-v1_2.git AthenaUI
cd AthenaUI
git checkout edulog-hallettsville
git pull

npm install
npm run postinstall
npm run build:prod

build_date=`date +%Y%m%d-%H%M`
tar -zcvf athena-ui-build-${build_date}.tar.gz dist

scp athena-ui-build-${build_date}.tar.gz ubuntu@10.0.137.132:/opt/edulog/AthenaUI
