#!/bin/bash

#
# Startup script (ec2 user-data) for this server.
# To view the output from running this visit /var/log/cloud-init-output.log
#

# set environment variables
echo "DIGDAG_DB_USER=${postgres_user}" >> /etc/environment
echo "DIGDAG_DB_PASSWORD=${postgres_password}" >> /etc/environment
echo "DIGDAG_DB_HOST=${postgres_host}" >> /etc/environment
echo "DIGDAG_DB_PORT=${postgres_port}" >> /etc/environment
echo "DIGDAG_DB_NAME=${postgres_db_name}" >> /etc/environment
echo "DIGDAG_S3_BUCKET=${digdag_s3_bucket}" >> /etc/environment
echo "MAIL_HOST=${mail_host}" >>  /etc/environment
echo "MAIL_FROM=${email_address}" >> /etc/environment
echo "MAIL_USERNAME=${mail_username}" >>  /etc/environment
echo "MAIL_PASSWORD=${mail_password}" >>  /etc/environment
echo "DOMAIN=${full_record_name}" >> /etc/environment
echo "RECORD_NAME=${record_name}" >> /etc/environment
echo "PROXY_ADMIN_PASSWORD=${proxy_admin_password}" >> /etc/environment
echo "PAPERTRAIL_URL=${papertrail_url}" >> /etc/environment
echo "STAGE=${stage}" >> /etc/environment
echo "GITHUB_USER=${github_user}" >> /etc/environment
echo "GITHUB_TOKEN=${github_token}" >> /etc/environment
echo "GITHUB_REPO_URL=${github_repo_url}" >> /etc/environment

# Gives you a root prompt with a new shell environment
sudo -i
# setup and run digdag and nginx
git clone "https://${github_user}:${github_token}@${github_repo_url}" /opt/app

/bin/bash /opt/app/server/digdag/config.sh

/bin/bash /opt/app/server/nginx/config.sh
