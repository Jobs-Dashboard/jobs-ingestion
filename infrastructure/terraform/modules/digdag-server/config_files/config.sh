#!/bin/bash

#
# Startup script (ec2 user-data) for this server.
# To view the output from running this visit /var/log/cloud-init-output.log
#

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
echo "GITHUB_USER=${github_user}" >> /etc/environment
echo "GITHUB_TOKEN${github_token}" >> /etc/environment
echo "GITHUB_REPO_URL${github_repo_url}" >> /etc/environment

# setup and run digdag and nginx
sudo git clone "https://${github_user}:${github_token}@${github_repo_url}" /opt/app
/bin/bash /opt/app/server/digdag/config.sh

#/bin/bash /opt/app/server/nginx/config.sh

# export DIGDAG_DB_USER=digdag \
# export DIGDAG_DB_PASSWORD=N4K2wq4uZJJm9xDFUv5V \
# export DIGDAG_DB_HOST=terraform-20201207173106960600000003.cr4lapnnmyeg.eu-west-1.rds.amazonaws.com \
# export DIGDAG_DB_NAME=DigdagDB \
# export DIGDAG_S3_BUCKET=044026092812-jobs-ingestion-production-digdag \
# export MAIL_HOST=email-smtp.eu-west-1.amazonaws.com \
# export MAIL_FROM=jobs.dashboard.data@gmail.com \
# export MAIL_USERNAME=AKIAQUQBI3UGBG43FDHT \
# export MAIL_PASSWORD=BKDi6X7vM5YLKVhNYUqoqhmb+7zdwCIUSmLKOudKVsdP \
# export DOMAIN=digdag.jobs-dashboard.ml \
# export RECORD_NAME=digdag \
# export PROXY_ADMIN_PASSWORD=SxXffn7aNmVPytLK7M8e \
# export PAPERTRAIL_URL=logs6.papertrailapp.com:30178 \
# export STAGE=production \
# export GITHUB_USER=buedaswag \
# export GITHUB_TOKEN=37857a39a587e57dee2bf3b8b16b3f47a1ee7a4f \
# export GITHUB_REPO_URL=github.com/Jobs-Dashboard/jobs-ingestion.git

# sudo git clone "https://${github_user}:${github_token}@${github_repo_url}" /opt/app
# sudo git clone "https://buedaswag:37857a39a587e57dee2bf3b8b16b3f47a1ee7a4f@github.com/Jobs-Dashboard/jobs-ingestion.git" /opt/app

# www.jobs.dashboard.data@gmail.com jobs.dashboard.data@gmail.com;



# # Virtual Host configuration for example.com
# #
# # You can move that to a different file under sites-available/ and symlink that
# # to sites-enabled/ to enable it.
# #
# #server {
# #       listen 80;
# #       listen [::]:80;
# #
# #       server_name example.com;
# #
# #       location / {
# #               try_files $uri $uri/ =404;
# #       }
# #}
