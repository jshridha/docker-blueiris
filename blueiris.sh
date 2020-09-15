#!/bin/bash

BLUEIRIS_EXE="/home/wineuser/prefix/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}/BlueIris.exe"
BLUEIRIS_INSTALL_PATH="/home/wineuser/prefix/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}"
PREFIX_DIR="/home/wineuser/prefix"
INSTALL_EXE="/home/wineuser/blueiris.exe"

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
  winetricks win10
  winetricks -q corefonts wininet vcrun2019 mfc42
fi


if [ ! -e "$BLUEIRIS_EXE" ] ; then
    if [ ! -e "$INSTALL_EXE" ] ; then
        if [ "$BLUEIRIS_VERSION" == "4" ]; then
           wget -O blueiris.exe https://blueirissoftware.com/BlueIris_48603.exe
        else
           wget https://blueirissoftware.com/blueiris.exe
        fi
    fi
    wine "blueiris.exe"
    rm blueiris.exe
    if [ "$BLUEIRIS_VERSION" == "5" ]; then
       unzip -o "${BLUEIRIS_INSTALL_PATH}/ui3.zip" -d "${BLUEIRIS_INSTALL_PATH}/www/"
    fi
    wine reg import service.reg && sleep 5
    kill 1
fi
wine reg import service.reg && sleep 5 && wine net start blueiris && sleep 5
wine "${BLUEIRIS_EXE}"
