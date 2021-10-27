# En Desarrollo / Under development

[Guidelines for this project in English](docs/README_en.md)

Esta imagen de docker es un contenedor alpine linux con openvpn punto a punto.

## Guía del proyecto:

El contenedor tiene dos modos, mediante los parámetros del yml podemos optar por utilizar una configuración personalizada o una configuración que se auto-genera.

## Parámetros:

- CUSTOM_CFG (Obligatorio, setear yes|no, **yes:** se utilizará una configuración personalizada, **no:** se utilizará una configuración auto-generada.)

- CONFIG_FILE (Obligatorio si CUSTOM_CFG=yes, Se debe especificar el nombre de la configuración personalizada que luego será montada desde el volumen /data)

**Las siguientes variables de entorno son obligatorias si custom_cfg=no**

- REMOTE_IP (IP pública o dirección url del nodo remoto)

- FLOAT (yes|no, Se refiere a la IP pública, generalmente setear no)

- PORT (Puerto UDP a ser utilizado por el tunel)

- TUN_LOCAL_IP (ip local del tunel)

- TUN_REMOTE_IP (ip remota del tunel)

- KEY (Nombre del archivo que contiene la llave de la VPN)

- ROUTES ( Ruta hacia la red privada remota, ej: route 192.168.111.0 255.255.255.0)

- LOG_NAME (Nombre del archivo donde se escriben los logs del openvpn)

- CONFIG_NAME (Nombre que recibirá el archivo de configuración)


## Modo de uso:
Para establecer la vpn entre dos nodos, debemos montar un contenedor en cada extremo, asumimos que utilizamos una configuración auto-generada, ambos equipos tienen docker y docker-compose instalado y tienen habilitado el IP_Fordwarding. Además, desde el Gateway está configurado el DNAT del puerto UDP utilizado así como todas las reglas de Firewall definidas.

|#| IP |Tunel IP|GATEWAY|IP PUBLICA|
|--|--|--|--|--|
|Nodo 1|192.168.10.100|10.0.0.1|192.168.10.1|xx.xx.xx.125|
|Nodo 2|192.168.20.100|10.0.0.2|192.168.20.1|xx.xx.xx.140|

### Nodo 1, archivo nodo1.yml
     version: '3.5'
     services:
         openvpn:
             image: tamuxx/openvpn_p2p
             container_name: ovpn_p2p
             cap_add:
                 - NET_ADMIN
             restart: unless-stopped
             environment:
                 - CUSTOM_CFG=no                 
                 - REMOTE_IP=xx.xx.xx.140 
                 - FLOAT=no 
                 - PORT=1200
                 - TUN_LOCAL_IP=10.0.0.1
                 - TUN_REMOTE_IP=10.0.0.2
                 - KEY=key_test.key #llave previamente generada en el directorio "/directory/to/mount".
                 - ROUTES=route 192.168.20.0 255.255.255.0 #ruteo a la red privada remota.
                 - LOG_NAME=ovpn_nodo1.log
                 - CONFIG_NAME=ovpn_nodo1
             volumes:
                 - /directory/to/mount:/data
             network_mode: host

# docker-compose -f nodo1.yml up -d





## Tareas pendientes para testear y documentar:
If you need generate a key, you can run: 
$ docker exec [container_name] /usr/sbin/openvpn --genkey secret /data/key_test.key
testear net_cap, tal vez es privilegio suficiente

