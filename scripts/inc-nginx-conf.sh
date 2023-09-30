#!/bin/bash

echo 'events {
	worker_connections 1024;
}

http {
	# Hide nginx version
	server_tokens off;

	# Enable gzip compression
	gzip on;
	gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  	# Include server blocks
	server {
		listen 80;
		server_name '$DOMAIN';
		location / {
			return 301 https://$host$request_uri;
		}
	}

	server {
		listen 443 ssl;
		server_name '$DOMAIN';
		
		ssl_certificate /etc/nginx/ssl/server.crt;
		ssl_certificate_key /etc/nginx/ssl/server.key;

		location / {
			# Proxy main Jellyfin traffic
			proxy_pass http://jellyweb-media:8096;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header X-Forwarded-Protocol $scheme;
			proxy_set_header X-Forwarded-Host $http_host;

			# Disable buffering when the nginx proxy gets very resource heavy upon streaming
			proxy_buffering off;
		}

		# location block for /web - This is purely for aesthetics so /web/#!/ works instead of having to go to /web/index.html/#!/
		location = /web/ {
			# Proxy main Jellyfin traffic
			proxy_pass http://jellyweb-media:8096/web/index.html;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header X-Forwarded-Protocol $scheme;
			proxy_set_header X-Forwarded-Host $http_host;
		}

		location /socket {
			# Proxy Jellyfin Websockets traffic
			proxy_pass http://jellyweb-media:8096;
			proxy_http_version 1.1;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection "upgrade";
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
			proxy_set_header X-Forwarded-Protocol $scheme;
			proxy_set_header X-Forwarded-Host $http_host;
		}
	}
}'