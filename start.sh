#!/bin/bash
service ssh start
service dbus start

xpra_config() {
    sed -i "s/\<CONTAINER_IP\>/${1}/g" /etc/xpra/xpra.conf
}

xpra_start() {
    gosu viptela \
         xpra start :200 \
         --bind-tcp=0.0.0.0:10000 \
         --html=on \
         --pulseaudio=no \
         --sharing=yes \
         --speaker=disabled \
         --microphone=disabled \
         --csc-modules=opencl \
         --opengl=yes \
         --dpi=96
}

xpra_connect() {
    xpra_config
    xpra_start
    tail -f /home/viptela/.xpra/\:200.log
}

! [ $# -eq 0 ] && xpra_connect || exec /bin/bash -l
