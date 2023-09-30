#!/bin/bash

echo 'FROM nginx:alpine

RUN apk update
RUN apk add openssl

ENV HOSTNAME='$DOMAIN'

COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl

RUN openssl genrsa -out /etc/nginx/ssl/server.key 2048 && \
    openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/C=UK/ST=West Midlands/L=Wolverhampton/O=Jack Cowling/CN='$DOMAIN'" && \
    openssl x509 -req -days 365 -in /etc/nginx/ssl/server.csr -signkey /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt

EXPOSE 80
EXPOSE 443
EXPOSE 14952
EXPOSE 14953

CMD ["nginx", "-g", "daemon off;"]'