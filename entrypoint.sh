#!/bin/sh
mkdir /var/empty/tmp
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
exec /usr/sbin/openvpn --config /data/$CONFIG_FILE
