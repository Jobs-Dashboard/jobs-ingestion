#!/bin/bash

# install dependencies
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install apache2-utils -y
sudo apt-get install python-certbot-nginx -y
sudo certbot --nginx -d "${DOMAIN}" -d www."${DOMAIN}"

# configure nginx
rm /etc/nginx/conf.d/default.conf
cp nginx.conf /etc/nginx/nginx.conf
export DOLLAR='$' && \
envsubst < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

# create password file
htpasswd -b -c /etc/nginx/.htpasswd admin "${PROXY_ADMIN_PASSWORD}"

# start nginx
sudo service nginx restart
