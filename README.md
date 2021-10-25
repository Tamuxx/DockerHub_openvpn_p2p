# Under development

This docker image is an alpine linux container with openvpn point to point.

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

### Nodo 1
     version: '3.6'
     services:
     onvpn2:
     image: ovpn:2.0
     container_name: ovpn_2_0
     cap_add:
     - NET_ADMIN
     restart: unless-stopped
     environment:
    - CUSTOM_CFG=no #Mandatory yes|no
    - CONFIG_FILE=test.conf #Mandatory if custom_cfg=yes
    - REMOTE_IP=1.1.1.1 #from here, mandatory if custom_cfg=no
    - FLOAT=no #yes|no
    - PORT=9001
    - TUN_LOCAL_IP=10.9.9.1
    - TUN_REMOTE_IP=10.9.9.2
    - KEY=key_test.key
    - ROUTES=route 192.168.111.0 255.255.255.0
    - LOG_NAME=prueba.log
    - CONFIG_NAME=prueba
    volumes:
    - /opt/docker_data/ovpn:/data





## Tareas pendientes para testear y documentar:
If you need generate a key, you can run: 
$ docker exec [container_name] /usr/sbin/openvpn --genkey secret /data/key_test.key
testear net_cap, tal vez es privilegio suficiente

