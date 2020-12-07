#!/bin/bash

# install dependencies
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install apache2-utils -y
sudo apt-get install python-certbot-nginx -y

# create password file
htpasswd -b -c /etc/nginx/.htpasswd admin "${PROXY_ADMIN_PASSWORD}"

# configure nginx
rm /etc/nginx/conf.d/default.conf
cp nginx.conf /etc/nginx/nginx.conf
export DOLLAR='$' && \
envsubst < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

# start nginx
sudo service nginx restart

# run certbot
sudo certbot run -n --nginx --agree-tos \
-d "${DOMAIN}",www."${DOMAIN}"  -m  "${MAIL_FROM}"  --redirect

