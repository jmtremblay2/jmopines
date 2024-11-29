#!/bin/bash

docker run \
  --name jmopines-nginx \
  -v /home/jm/sites/jmopines/public:/usr/share/nginx/html \
  -v /home/jm/sites/jmopines/nginx.conf:/etc/nginx/nginx.conf \
  -p 10555:80 \
  --entrypoint="nginx" \
  nginx:alpine -g "daemon off;"