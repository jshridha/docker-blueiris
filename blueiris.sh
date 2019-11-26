#!/bin/bash

BLUEIRIS_EXE="/root/prefix32/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}/BlueIris.exe"
PREFIX_DIR="/root/prefix32"
INSTALL_EXE="/root/blueiris.exe"

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
    mv /root/prefix32_original/* /root/prefix32
fi

chown -R root:root /root/prefix32

if [ ! -e "$BLUEIRIS_EXE" ] ; then
    if [ ! -e "$INSTALL_EXE" ] ; then
        if [ "$BLUEIRIS_VERSION" == "4" ]; then
           wget -O blueiris.exe https://blueirissoftware.com/BlueIris_48603.exe
        else
           wget http://blueirissoftware.com/blueiris.exe
        fi
    fi
    wine blueiris.exe
    rm blueiris.exe
fi

wine "$BLUEIRIS_EXE"
