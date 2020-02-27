FROM debian:buster-slim

# ngrok is designed to be self-updating, which is a pain when you want immutable images
# URLs for download are not predictable and no public API that I can find.
# So scrape the archives page html for deb package :(

# get latest version
# curl -sS https://dl.equinox.io/ngrok/ngrok/stable | grep Version | sed -r 's/.*>Version (.*)<.*/\1/'

# get package url
# curl -sS ${NGROK_ARCHIVE_URL} | grep ngrok-${NGROK_VERSION}-linux-amd64.deb | sed -r 's/^.*href="(.*)" .*$/\1/'

ARG NGROK_URL

RUN apt-get update && \
    apt-get install -y curl bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS -o /tmp/ngrok.deb ${NGROK_URL} && \
    dpkg -i /tmp/ngrok.deb

RUN useradd -ms /bin/bash ngrok

USER ngrok

CMD [ "ngrok" ]
