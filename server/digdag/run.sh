#!/bin/bash

mkdir -p ./digdag/log
mkdir -p ./digdag/sessions

# All of these can be set in the docker-compose files

echo "
server.bind=0.0.0.0
server.port=9090
server.admin.bind=0.0.0.0
server.admin.port=9091
database.maximumPoolSize=10
database.type=postgresql
database.user=${DIGDAG_DB_USER}
database.password=${DIGDAG_DB_PASSWORD}
database.host=${DIGDAG_DB_HOST}
database.port=${DIGDAG_DB_PORT}
database.database=${DIGDAG_DB_NAME}
" > digdag_server.properties

# In production we want to store all of the assets in s3
if [ "$DIGDAG_ENV" == 'prod' ]; then
  echo "
  archive.type=s3
  archive.s3.bucket=${DIGDAG_S3_BUCKET}
  archive.s3.path=/archive
  log-server.type=s3
  log-server.bucket=${DIGDAG_S3_BUCKET}
  log-server.path=/logs
  config.mail.tls=true
  config.mail.ssl=false
  config.mail.from=${MAIL_FROM}
  config.mail.host=${MAIL_HOST}
  config.mail.port=${MAIL_PORT}
  config.mail.username=${MAIL_USERNAME}
  config.mail.password=${MAIL_PASSWORD}

  " >> digdag_server.properties
fi

# Now run the server using the properties file created above
digdag server \
  --task-log ./digdag/sessions/ \
  --max-task-threads 5 \
  --config ./digdag_server.properties
