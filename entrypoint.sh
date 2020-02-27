#!/bin/bash

set -e

NGROK_HOME="/home/ngrok/.ngrok2"
NGROK_CONFIG="${NGROK_HOME}/ngrok.yml"
NGROK_IMPORT_CONFIG="/maps/ngrok/ngrok.yml"

if [ ! -d "${NGROK_HOME}" ]; then
    mkdir -p ${NGROK_HOME}
fi

if [ -f ${NGROK_IMPORT_CONFIG} ]; then
    cp ${NGROK_IMPORT_CONFIG} ${NGROK_CONFIG}
    echo "web_addr: 0.0.0.0:4040" >> ${NGROK_CONFIG}
fi

if [ ! -z "${NGROK_AUTHTOKEN}" ]; then
    echo "authtoken: ${NGROK_AUTHTOKEN}" >> ${NGROK_CONFIG}
fi

exec "$@"
