FROM debian:buster-slim AS download

# ngrok is designed to be self-updating, which is a pain when you want immutable images
# URLs for download are not predictable and no public API that I can find.
# So scrape the archives page html for deb package :(

# get latest version
# curl -sS https://dl.equinox.io/ngrok/ngrok/stable | grep Version | sed -r 's/.*>Version (.*)<.*/\1/'

# get package url
# curl -sS ${NGROK_ARCHIVE_URL} | grep ngrok-${NGROK_VERSION}-linux-amd64.deb | sed -r 's/^.*href="(.*)" .*$/\1/'

ARG NGROK_URL

RUN apt-get update && \
    apt-get install -y curl

RUN curl -sS -o /tmp/ngrok.deb ${NGROK_URL}

# ----------- #

FROM debian:buster-slim

COPY --from=download /tmp/ngrok.deb /tmp/ngrok.deb

RUN useradd -m -s /bin/bash ngrok && \
    apt-get update && \
    apt-get install -y ca-certificates && \
    dpkg -i /tmp/ngrok.deb && \
    apt-get clean && \
    rm -rf /tmp/ngrok.deb /var/lib/apt/lists/*

USER ngrok

ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 4040

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "ngrok", "start", "--all", "--log", "stdout"]
