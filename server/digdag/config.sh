#!/bin/bash

# install dependencies
sudo apt update
sudo apt install default-jdk -y
curl -o /bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-0.9.41"
chmod +x /bin/digdag

# install python dependencies
sudo apt update && sudo apt install python3-pip python3-venv
python3 -m pip install --user --upgrade pip setuptools wheel
python3 -m venv ~/.virtualenvs/venv
source ~/.virtualenvs/venv/bin/activate
pip install -U pip
pip install -r /opt/app/server/digdag/requirements.txt

# configure digdag
cd /usr/src/app
mkdir -p ./digdag/log
mkdir -p ./digdag/sessions

echo "
server.bind=0.0.0.0
server.port=9090
server.admin.bind=0.0.0.0
server.admin.port=9091
database.maximumPoolSize=10
" > digdag_server.properties

# In production we want to store all of the assets in s3
if [ "$DIGDAG_ENV" == 'production' ]; then
  echo "
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
" >> digdag_server.properties
fi

# run digdag
digdag server \
  --task-log ./digdag/sessions/ \
  --max-task-threads 5 \
  --config ./digdag_server.properties
