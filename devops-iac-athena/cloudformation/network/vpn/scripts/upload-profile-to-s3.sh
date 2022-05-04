!/bin/bash

# Upload ovpn and rsa key to S3
home_dir=/home/ubuntu/client-configs/files
ovpn_file=${home_dir}/$1.ovpn
rsa_file=${home_dir}/$2.rsa
aws s3 cp --acl public-read ${ovpn_file} ${rsa_file} s3://edulog-internal-shorterm/vpn/
