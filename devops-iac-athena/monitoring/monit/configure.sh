#!/bin/bash -xe

# Installing Monit on Ubuntu 16.04/18.04
sudo su -

## Updating System Packages
[apt-get update]
[sudo apt-get upgrade -y]

## Installation
apt install monit -y

## Add Athena Services Monitoring & Auto Healing

cat << EOF > /etc/monit/conf-enabled/athena-services
check program gateway with path "/bin/systemctl --quiet is-active gateway"
    start program = "/bin/systemctl start gateway" with timeout 30 seconds
    stop program  = "/bin/systemctl stop gateway"
    if status != 0 then restart

check program middle with path "/bin/systemctl --quiet is-active middle"
    start program = "/bin/systemctl start middle" with timeout 30 seconds
    stop program  = "/bin/systemctl stop middle"
    if status != 0 then restart

check program backend with path "/bin/systemctl --quiet is-active backend"
    start program = "/bin/systemctl start backend" with timeout 30 seconds
    stop program  = "/bin/systemctl stop backend"
    if status != 0 then restart
    
check program geocodeservice with path "/bin/systemctl --quiet is-active geocodeservice"
    start program = "/bin/systemctl start geocodeservice" with timeout 30 seconds
    stop program  = "/bin/systemctl stop geocodeservice"
    if status != 0 then restart
EOF

## Verify & Enable Monit Service
systemctl enable monit
systemctl restart monit
systemctl status monit

## Verify log
tail -f /var/log/monit.log
