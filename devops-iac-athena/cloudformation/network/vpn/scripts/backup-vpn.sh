#!/bin/bash -xe

base_dir=/home/ubuntu
/usr/bin/aws s3 cp --recursive $base_dir/client-configs/ s3://edulog-athena-backup/vpnServer/client-configs/
/usr/bin/aws s3 cp --recursive $base_dir/openvpn-ca/ s3://edulog-athena-backup/vpnServer/openvpn-ca/