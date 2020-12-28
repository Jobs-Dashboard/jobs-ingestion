#!/bin/bash

#
# Configuration script for nginx.
#

# install dependencies
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update && \
  sudo apt-get install nginx -y  && \
  sudo apt-get install apache2-utils -y  && \
  sudo apt-get install python-certbot-nginx -y

# create password file
password_file="/etc/nginx/.htpasswd"
htpasswd -b -c $password_file admin "${PROXY_ADMIN_PASSWORD}"

# Create the Nginx server block file:
# adding > /dev/null to prevent the contents of the here file
# being displayed to stdout when it's created
block="/etc/nginx/sites-available/$DOMAIN"
sudo tee $block > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN www.$DOMAIN;

    auth_basic "Restricted Content";
    auth_basic_user_file $password_file;

    location / {
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Authorization "";
        proxy_pass http://localhost:9090;
    }
}
EOF

# Link to make it available
ln -s $block /etc/nginx/sites-enabled/

# Remove the default site simlink
rm /etc/nginx/sites-enabled/default

# Test configuration and reload if successful
nginx -t && service nginx reload

# run certbot
sudo certbot run -n --nginx --agree-tos \
-d "${DOMAIN}",www."${DOMAIN}" -m "${MAIL_FROM}" --redirect
