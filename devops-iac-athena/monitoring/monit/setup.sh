#!/bin/bash -xe

# Installing Monit on Ubuntu 16.04/18.04

## Updating System Packages
sudo apt-get update && sudo apt-get upgrade

## Installation
sudo apt install monit -y

## Start Monit Daemon
sudo monit

## Verify & Enable Monit Service
sudo systemctl status monit
sudo systemctl enable monit

## Add Athena Services Monitoring & Auto Healing

cat << EOF > /etc/monit/conf-enabled/athena-services

EOF