#!/bin/bash

# First argument: client
client=$1
username=$2

# Revoke cert
cd /home/ubuntu/openvpn-ca
source vars
/home/ubuntu/openvpn-ca/revoke-full $client

# delete user
sudo userdel -r $username
