
# Install Keycloak
sudo apt-get update
sudo apt-get install default-jdk -y

cd /opt
sudo wget https://downloads.jboss.org/keycloak/9.0.0/keycloak-9.0.0.tar.gz
sudo tar -xvzf keycloak-9.0.0.tar.gz
sudo mv keycloak-9.0.0 keycloak
sudo groupadd keycloak
sudo useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak
sudo chown -R keycloak: keycloak
sudo chmod o+x /opt/keycloak/bin/
cd /etc/
sudo mkdir keycloak
sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf
sudo cp /opt/keycloak/docs/contrib/scripts/systemd/launch.sh /opt/keycloak/bin/
sudo chown keycloak: /opt/keycloak/bin/launch.sh
sudo vi /opt/keycloak/bin/launch.sh
sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/keycloak.service
sudo vi /etc/systemd/system/keycloak.service
sudo systemctl daemon-reload
sudo systemctl enable keycloak

# Setup SSL
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-nginx nginx -y
sudo vi /etc/nginx/conf.d/sso.sweetfamily.best.conf
sudo certbot --nginx -d sso.sweetfamily.best

# key:
#/etc/letsencrypt/live/sso.sweetfamily.best/privkey.pem
# cert:
#/etc/letsencrypt/live/sso.sweetfamily.best/fullchain.pem
sudo nginx -t
sudo systemctl restart nginx

# access authen page
# create admin account: 
# username: admin; pass: keycloak2303