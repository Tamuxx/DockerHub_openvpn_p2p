# Under development

This docker image is an alpine linux container with openvpn point to point.

If you need generate a key, you can run: 
$ docker exec [container_name] /bin/openvpn --genkey secret /data/key_test.key

testear net_cap, tal vez es privilegio suficiente
