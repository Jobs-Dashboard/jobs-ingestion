#!/bin/bash

#
# Configuration script for digdag.
#

# install dependencies
sudo apt update && \
  sudo apt install default-jdk -y && \
  sudo apt install python3-pip python3-venv -y

# get digdag
sudo curl -o /bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-0.9.41"
sudo chmod +x /bin/digdag

# setup venv
python3 -m pip install --user --upgrade pip setuptools wheel
python3 -m venv ~/.virtualenvs/venv
source ~/.virtualenvs/venv/bin/activate
pip install -U pip setuptools wheel
pip install -r /opt/app/server/digdag/requirements.txt

# configure digdag
sudo mkdir -p /usr/src/app
cd /usr/src/app
sudo mkdir -p ./digdag/log
sudo mkdir -p ./digdag/sessions

echo "
server.bind=0.0.0.0
server.port=9090
server.admin.bind=0.0.0.0
server.admin.port=9091
database.maximumPoolSize=10
archive.type=s3
archive.s3.bucket=${DIGDAG_S3_BUCKET}
archive.s3.path=/archive
log-server.type=s3
log-server.bucket=${DIGDAG_S3_BUCKET}
log-server.path=/logs
config.mail.tls=true
config.mail.ssl=false
database.type=postgresql
database.user=${DIGDAG_DB_USER}
database.password=${DIGDAG_DB_PASSWORD}
database.host=${DIGDAG_DB_HOST}
database.port=${DIGDAG_DB_PORT}
database.database=${DIGDAG_DB_NAME}
" > digdag_server.properties

# write the digdag service script
echo "
/bin/digdag server \
  --task-log /usr/src/app/digdag/sessions/ \
  --max-task-threads 5 \
  --config /usr/src/app/digdag_server.properties
" > run_digdag.ch
sudo chmod +x run_digdag.ch

# write the digdag service description
echo "
[Unit]
Description=digdag

[Service]
ExecStart=/bin/bash /usr/src/app/run_digdag.ch
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/digdag.service

# start digdag
service digdag start
