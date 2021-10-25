# Under development

This docker image is an alpine linux container with openvpn point to point.
El contenedor tiene dos modos, mediante los parámetros del yml podemos optar por utilizar una configuración personalizada o una configuración que se auto-genera.

## Parámetros:
 - CUSTOM_CFG (Obligatorio, setear yes|no, **yes:** se utilizará una configuración personalizada, **no:** se utilizará una configuración auto-generada.)

- CONFIG_FILE (Obligatorio si CUSTOM_CFG=yes, Se debe especidifcar el nombre de la configuración personalizada que luego será montada desde el volumen /data)

Las siguientes variables de entorno son obligatorias si custom_cfg=no

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
Para establecer la vpn entre dos nodos, debemos montar un contenedor en cada extremo.

### Nodo 1




## Tareas pendientes para testear y documentar:
If you need generate a key, you can run: 
$ docker exec [container_name] /usr/sbin/openvpn --genkey secret /data/key_test.key
testear net_cap, tal vez es privilegio suficiente
