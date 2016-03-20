#!/bin/bash
service ssh start

start_xpra() {
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

start_xpra

! [ $# -eq 0 ] && exec $@ || exec /bin/bash -l
