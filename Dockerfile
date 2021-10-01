# v1.0
# Generar con:
# docker build -t openvpn_server:1.0 .
FROM alpine:3.14.0
RUN apk --no-cache add openvpn
#RUN mkdir /var/empty/tmp
#RUN mkdir -p /dev/net
#RUN mknod /dev/net/tun c 10 200

EXPOSE 7000/udp

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

RUN mkdir /data

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
