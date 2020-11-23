#!/bin/bash

echo "DIGDAG_DB_USER='${postgres_user}'" >> /etc/environment
echo "DIGDAG_DB_PASSWORD='${postgres_password}'" >> /etc/environment
echo "DIGDAG_DB_HOST='${postgres_host}'" >> /etc/environment
echo "DIGDAG_DB_NAME='${postgres_db_name}'" >> /etc/environment
echo "DIGDAG_S3_BUCKET='${digdag_s3_bucket}'" >> /etc/environment
echo "MAIL_FROM='${email_address}'" >> /etc/environment
echo "MAIL_HOST='${mail_host}'" >>  /etc/environment
echo "MAIL_USERNAME='${mail_username}'" >>  /etc/environment
echo "MAIL_PASSWORD='${mail_password}'" >>  /etc/environment
echo "DIGDAG_SSL_DOMAIN=${digdag_ssl_domain}" >> /etc/environment
echo "PAPERTRAIL_URL=${papertrail_url}" >> /etc/environment

# `sudo -i` gives you a root prompt with a new shell environment
# (as if root did a login). Does a cd to root's home directory as well.
sudo -i
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo apt install -y apache2-utils  # installs htpasswd
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo apt install -y make
sudo git clone "https://${github_user}:${github_token}@${github_repo_url}" /opt/app
sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
cd /opt/app/server
htpasswd -b -c nginx/.htpasswd admin ${proxy_admin_password}
sudo make dc-start
