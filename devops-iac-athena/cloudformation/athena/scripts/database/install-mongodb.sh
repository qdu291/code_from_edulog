#!/bin/bash


# install MongoDB
echo "Installing MongoDB"
apt-get install -y mongodb
systemctl status mongodb