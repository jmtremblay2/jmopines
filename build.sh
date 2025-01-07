#!/bin/bash
set -x
set -e

# create the public repository if it does not exist
sudo mkdir -p /public
sudo chown $(whoami):$(whoami) /public

# site name, create destination name
SITE=$(basename "$PWD")
DEST="/public/${SITE}"
mkdir -p ${DEST}
# maybe make this an option... need to verify what happens
# to the public folder on successive builds
rm -rf ${DEST}/*

echo "building ${SITE} to ${DEST}"
docker run -it \
    -v "$(pwd)/":/site/ \
    -v "${DEST}":/public/ \
    -u $(id -u):$(id -g)\
    hugomods/hugo \
    hugo build -s /site -d /public

rm -rf ${DEST}/nginx.conf
cp -f nginx.conf ${DEST}/nginx.conf
