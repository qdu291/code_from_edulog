#!/bin/bash

#echo "ovpn & rsa files will be uploaded to s3 $1 and $2"
home_dir=/home/ubuntu/client-configs/files
ovpn_file=${home_dir}/$1.ovpn
rsa_file=${home_dir}/$2.pem
aws s3 cp --acl public-read ${ovpn_file} s3://edulog-internal-shorterm/vpn/
aws s3 cp --acl public-read ${rsa_file} s3://edulog-internal-shorterm/vpn/

mkdir -p ${home_dir}/$2
mv ${ovpn_file} ${home_dir}/$2
mv ${rsa_file} ${home_dir}/$2
