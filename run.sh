#!/bin/bash
set -x
set -e  # Exit on error
echo "Starting Nginx container..."

docker run \
  --name jmopines-nginx \
  --rm \
  -v /public/jmopines:/usr/share/nginx/html \
  -v /public/jmopines/nginx.conf:/etc/nginx/nginx.conf \
  -p 10555:80 \
  --entrypoint="nginx" \
  nginx:alpine -g "daemon off;"

echo "Container started successfully"