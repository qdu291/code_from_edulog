
sudo apt-get update
sudo apt-get install openvpn easy-rsa -y
cd ~
dd if=/dev/urandom of=.rnd bs=256 count=1
make-cadir ~/openvpn-ca
cd ~/openvpn-ca/
vi vars
source vars
./clean-all
cp -p openssl-1.0.0.cnf openssl.cnf
./build-ca --batch
./build-key-server --batch server
./build-dh --batch
openvpn --genkey --secret keys/ta.key

./build-key --batch client1

# use option --batch for filling in vars params 
cd ~/openvpn-ca/keys
sudo cp ca.crt server.crt server.key ta.key dh2048.pem /etc/openvpn


gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf

sudo vi /etc/openvpn/server.conf

sudo vi /etc/sysctl.conf
--------------------------
net.ipv4.ip_forward=1

sudo sysctl -p

sudo vi /etc/ufw/before.rules

*******************************
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0] 
# Allow traffic from OpenVPN client to wlp11s0 (change to the interface you discovered!)
-A POSTROUTING -s 10.8.0.0/8 -o ens5 -j MASQUERADE
COMMIT
# END OPENVPN RULES
*******************************

sudo vi /etc/default/ufw
*******************************
DEFAULT_FORWARD_POLICY="ACCEPT"
*******************************

sudo ufw allow 1194/udp
sudo ufw allow OpenSSH

sudo ufw disable
sudo ufw enable

sudo iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE

sudo systemctl start openvpn@server
sudo systemctl status openvpn@server

ip addr show tun0

mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf

sudo vi ~/client-configs/base.conf

vi ~/client-configs/make_config.sh
chmod 700 ~/client-configs/make_config.sh

cd ~/client-configs
./make_config.sh client1

adduser tan.khuu --force-badname