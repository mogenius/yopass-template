# FROM golang:buster as app
FROM jhaals/yopass

LABEL "com.mogenius.vendor"="Mogenius"
LABEL version="1.0"
LABEL description="TYopass - Share Secrets Securely \
Yopass is a project for sharing secrets in a quick and secure manner*. \
The sole purpose of Yopass is to minimize the amount of passwords floating \
around in ticket management systems, Slack messages and emails. The message \
is encrypted/decrypted locally in the browser and then sent to yopass without \
the decryption key which is only visible once during encryption, yopass then \
returns a one-time URL with specified expiry date. \
There is no perfect way of sharing secrets online and there is a trade off \
in every implementation. Yopass is designed to be as simple and "dumb" as \
possible without compromising on security. There's no mapping between the \
generated UUID and the user that submitted the encrypted message. It's always \
best send all the context except password over another channel."


ENV MEMCACHED_USER=nobody \
    MEMCACHED_VERSION=1.5.6

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      memcached=${MEMCACHED_VERSION}* \
 && sed 's/^-d/# -d/' -i /etc/memcached.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 11211/tcp 11211/udp
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/bin/memcached"]
