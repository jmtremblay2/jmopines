#!/bin/bash

docker run\
    -v /home/jm/sites/jmopines/public:/usr/share/nginx/html\
    -p 10555:80 nginx:alpine 