FROM nginx:alpine

RUN apk add --update openssl python3 python3-dev py3-pip build-base libressl-dev musl-dev libffi-dev rust cargo

ENV HOSTNAME=media.jackcowling.local

COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl

RUN openssl genrsa -out /etc/nginx/ssl/server.key 2048 && \
    openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/C=UK/ST=West Midlands/L=Wolverhampton/O=Jack Cowling/CN=media.jackcowling.local" && \
    openssl x509 -req -days 365 -in /etc/nginx/ssl/server.csr -signkey /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt
    
RUN pip3 install pip --upgrade
RUN pip3 install certbot-nginx

RUN mkdir /etc/letsencrypt

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
