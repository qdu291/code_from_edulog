#!/bin/bash
username=$1
email=$2
password=$3

# Create user
sudo useradd -m -s "/bin/bash" -p $(openssl passwd -1 ${password}) -c "${email}" ${username}
sudo mkdir -p /home/${username}/.ssh
sudo chmod 700 /home/${username}/.ssh
sudo touch /home/${username}/.ssh/authorized_keys
sudo chmod 600 /home/${username}/.ssh/authorized_keys
sudo chown ${username}: /home/${username}/.ssh
sudo chown ${username}: /home/${username}/.ssh/authorized_keys

# Generate RSA Key for new user
sudo su ${username} -c "ssh-keygen -f /home/${username}/.ssh/id_rsa -t rsa -N ''"
sudo su ${username} -c "cat /home/${username}/.ssh/id_rsa.pub" | sudo tee -a /home/${username}/.ssh/authorized_keys
sudo mv /home/${username}/.ssh/id_rsa /home/ubuntu/client-configs/files/${username}.pem
sudo chown ubuntu: /home/ubuntu/client-configs/files/${username}.pem
