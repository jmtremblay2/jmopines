#!/bin/bash

# looks overkill but that way with a docker
# it's easier to control what version of hugo 
# I use

if [ -z "${PUBLIC_DEST}" ]; then 
    DEST="/sites/${HUGO_SITE}/public"
else
    DEST="${PUBLIC_DEST}"
fi

echo "building ${SITES_ROOT}/${HUGO_SITE} to ${DEST}"

docker run -it \
    -v "${SITES_ROOT}/":/sites/ \
    -v "${HOME}/public/":/public/ \
    -u $(id -u):$(id -g)\
    hugomods/hugo \
    hugo build -s /sites/${HUGO_SITE} -d ${DEST}
