#!/bin/bash

export CONTAINER_IP=$(ip addr show eth0 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)")
export IP_ADDR=$1
export PORT=$2
export PASSWD=$3
export SCREEN_RES=$4

services_start() {
    service ssh restart
    service dbus restart
    service cups restart
}

xpra_passwd() {
    echo "${PASSWD}" > /tmp/xpra_passwd.txt
}

xpra_start() {
    gosu xuser \
         xpra start :200 \
         --bind-tcp=0.0.0.0:${PORT} \
         --html=on \
         --sharing=yes \
         --pulseaudio=no \
         --speaker=disabled \
         --microphone=disabled \
         --csc-modules=all \
         --opengl=yes \
         --auth=file \
         --password-file=/tmp/xpra_passwd.txt \
         --idle-timeout=0 \
         --server-idle-timeout=0 \
         --dpi=96 \
         --mdns=no \
         --start-child="Xephyr :202 -ac -query ${IP_ADDR} -screen ${SCREEN_RES}"
}

xpra_connect() {
    xpra_passwd
    services_start
    xpra_start
    echo "******* Use this URL to access  **********************************************"
    echo "http://${CONTAINER_IP}:${PORT}/index.html?username=anything&password=${PASSWD}"
    echo "******************************************************************************"
    tail -f /home/xuser/.xpra/\:200.log
}

no_args() {
    echo "Generally, that's what you want:"
    echo ""
    echo "/start.sh 172.17.0.1 10000 mypassword 1280x800"
    echo ""
    echo "starting a login shell...."
    exec /bin/bash -l
}

[ $# -eq 4 ] && xpra_connect || no_args
