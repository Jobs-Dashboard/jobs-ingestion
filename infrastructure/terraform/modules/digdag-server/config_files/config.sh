#!/bin/bash

# set environment variables
echo "DIGDAG_DB_USER='${postgres_user}'" >> /etc/environment
echo "DIGDAG_DB_PASSWORD='${postgres_password}'" >> /etc/environment
echo "DIGDAG_DB_HOST='${postgres_host}'" >> /etc/environment
echo "DIGDAG_DB_NAME='${postgres_db_name}'" >> /etc/environment
echo "DIGDAG_S3_BUCKET='${digdag_s3_bucket}'" >> /etc/environment
echo "MAIL_HOST='${mail_host}'" >>  /etc/environment
echo "MAIL_FROM='${email_address}'" >> /etc/environment
echo "MAIL_USERNAME='${mail_username}'" >>  /etc/environment
echo "MAIL_PASSWORD='${mail_password}'" >>  /etc/environment
echo "DOMAIN=${full_record_name}" >> /etc/environment
echo "RECORD_NAME=${record_name}" >> /etc/environment
echo "PROXY_ADMIN_PASSWORD=${proxy_admin_password}" >> /etc/environment
echo "PAPERTRAIL_URL=${papertrail_url}" >> /etc/environment
echo "STAGE=${stage}" >> /etc/environment

# setup and run digdag and nginx
# same as the user ami created in terraform, this user has passwordless access to sudo
sudo su - ubuntu
git clone "https://${github_user}:${github_token}@${github_repo_url}" /opt/app
/opt/app/digdag/config.sh
/opt/app/nginx/config.sh
