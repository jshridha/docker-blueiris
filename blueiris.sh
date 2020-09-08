#!/bin/bash

BLUEIRIS_EXE="/root/prefix/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}/BlueIris.exe"
BLUEIRIS_INSTALL_PATH="/root/prefix/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}"
PREFIX_DIR="/root/prefix"
INSTALL_EXE="/root/blueiris.exe"

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
    mv /root/prefix_original/* /root/prefix
fi

chown -R root:root /root/prefix

if [ ! -e "$BLUEIRIS_EXE" ] ; then
    if [ ! -e "$INSTALL_EXE" ] ; then
        if [ "$BLUEIRIS_VERSION" == "4" ]; then
           wget -O blueiris.exe https://blueirissoftware.com/BlueIris_48603.exe
        else
           wget https://blueirissoftware.com/blueiris.exe
        fi
    fi
    winetricks -q vcrun2019 mfc42
    wine "blueiris.exe"
    rm blueiris.exe
    if [ "$BLUEIRIS_VERSION" == "5" ]; then
       unzip -o "${BLUEIRIS_INSTALL_PATH}/ui3.zip" -d "${BLUEIRIS_INSTALL_PATH}/www/"
    fi
    wine reg import service.reg && sleep 5
    kill 1
fi
unzip -o "${BLUEIRIS_INSTALL_PATH}/ui3.zip" -d "${BLUEIRIS_INSTALL_PATH}/www/"
wine reg import service.reg && sleep 2 && wine net start blueiris && sleep 2
wine "${BLUEIRIS_EXE}"
