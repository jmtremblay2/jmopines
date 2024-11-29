#!/bin/bash

# Check if the container is running and stop it if it is
if docker ps -q -f name=jmopines-nginx; then
    docker stop jmopines-nginx
fi

# Check if the container exists and remove it if it does
if docker container inspect jmopines-nginx > /dev/null 2>&1; then
    docker rm jmopines-nginx
fi

docker run \
  --name jmopines-nginx \
  -v /home/jm/sites/jmopines/public:/usr/share/nginx/html \
  -v /home/jm/sites/jmopines/nginx.conf:/etc/nginx/nginx.conf \
  -p 10555:80 \
  --entrypoint="nginx" \
  nginx:alpine -g "daemon off;"