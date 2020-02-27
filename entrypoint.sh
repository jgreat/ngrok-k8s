#!/bin/bash

set -e

echo "Starting entrypoint.sh"

NGROK_HOME="/home/ngrok/.ngrok2"
NGROK_CONFIG="${NGROK_HOME}/ngrok.yml"
NGROK_IMPORT_CONFIG="/maps/ngrok/ngrok.yml"

if [ ! -d "${NGROK_HOME}" ]; then
    mkdir -p ${NGROK_HOME}
fi

if [ -f ${NGROK_IMPORT_CONFIG} ]; then
    echo "Importing Config from ConfigMap"
    cp ${NGROK_IMPORT_CONFIG} ${NGROK_CONFIG}
    echo "web_addr: 0.0.0.0:4040" >> ${NGROK_CONFIG}
fi

if [ ! -z "${NGROK_AUTHTOKEN}" ]; then
    echo "Adding AUTHTOKEN to ${NGROK_CONFIG}"
    echo "authtoken: ${NGROK_AUTHTOKEN}" >> ${NGROK_CONFIG}
fi

echo "Finished entrypoint.sh"

if [ "${DEBUG}" ]; then
    echo "ConfigMap Config"
    cat ${NGROK_IMPORT_CONFIG}
    echo "ngrok Config"
    cat ${NGROK_CONFIG}
fi

exec "$@"
