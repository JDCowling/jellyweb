#!/bin/bash

echo '
version: "3"
services:
  jellyweb-media:
   image: jellyfin/jellyfin
   container_name: jellyweb-media
   volumes:
    - ./jellyfin/config:/config
    - ./jellyfin/cache:/cache
    - ./media:/media
   networks: 
    - jellyweb-net
   restart: 'unless-stopped'

  jellyweb-http:
   build:
    context: .
    dockerfile: Dockerfile
   container_name: jellyweb-http
   ports:
    - 80:80
    - 443:443
   networks:
    - jellyweb-net
   restart: 'unless-stopped'

networks:
  jellyweb-net:
    name: jellyweb-net
    external: false
'