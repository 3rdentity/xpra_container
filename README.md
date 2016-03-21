# xpra_container
Assuming there's some kind of Display Manager listening for XDMCP queries
i.e. your /etc/lightdm/lightdm.conf file contains:

```
[XDMCPServer]
enabled=true
port=177
```

## usage:
Exactly three parameters are required to run this container:
  1. IP address of XDMCP host
  2. TCP port inside the container to run xpra web interface on
  3. Password to access the aforementioned interface

```bash
export CONTAINER_NAME=xpra2web
export XDMCP_HOST=$(ip addr show docker0 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)")
export XPRA_HTML_PASSWD="mycoolpassword"
export DOCKER_HOST_PORT=15000
export CONTAINER_HTTP_PORT=10000
```

### without exposing ports on docker host

```bash
docker run --rm -ti --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD
```

### with exposing ports on docker host

```bash
docker run --rm -ti -p $DOCKER_HOST_PORT:$CONTAINER_HTTP_PORT --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD
```

## autostart

```bash
docker run --restart=always -d -ti -p $DOCKER_HOST_PORT:$CONTAINER_HTTP_PORT --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD
```

## accessing container
i.e. in your web browser:

```
http://localhost:15000/index.html?username=anything&password=<$XPRA_HTML_PASSWD>
```
