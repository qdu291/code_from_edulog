#!/bin/bash

# First argument: client
cd ~/openvpn-ca
source vars
./build-key --batch $1