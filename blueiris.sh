#!/bin/bash

BLUEIRIS_EXE="/root/prefix32/drive_c/Program Files/Blue Iris 4/BlueIris.exe"
PREFIX_DIR="/root/prefix32"

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
    mv /root/prefix32_original/* /root/prefix32
fi


if [ ! -e "$BLUEIRIS_EXE" ] ; then
    wget http://blueirissoftware.com/blueiris.exe
    wine blueiris.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    rm blueiris.exe
fi

wine "$BLUEIRIS_EXE"

