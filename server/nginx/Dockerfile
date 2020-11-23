FROM nginx:1.17.7

RUN rm /etc/nginx/conf.d/default.conf
ARG DIGDAG_SSL_DOMAIN

ADD nginx.conf /etc/nginx/nginx.conf
ADD .htpasswd /etc/nginx/.htpasswd

RUN export DOLLAR='$' && \
    export DIGDAG_SSL_DOMAIN=$DIGDAG_SSL_DOMAIN && \
    envsubst < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
