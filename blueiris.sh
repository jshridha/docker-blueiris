#!/bin/bash

PREFIX_DIR=${WINEPREFIX}
BLUEIRIS_EXE="$PREFIX_DIR/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}/BlueIris.exe"
BLUEIRIS_INSTALL_PATH="$PREFIX_DIR/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}"
WINE_PATH=${WINE_PATH:-/usr/bin/wine}

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
  winetricks win10
fi


if [ ! -e "$BLUEIRIS_EXE" ] ; then
    wine "/home/wineuser/blueiris_$BLUEIRIS_VERSION.exe"
    if [ "$BLUEIRIS_VERSION" == "5" ]; then
       unzip -o "${BLUEIRIS_INSTALL_PATH}/ui3.zip" -d "${BLUEIRIS_INSTALL_PATH}/www/"
    fi
fi

wine reg delete "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\BlueIris" /f | true
$WINE_PATH "${BLUEIRIS_EXE}"
