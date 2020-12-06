#!/bin/bash

WINE_PATH=${WINE_PATH:-/usr/bin/wine}
sleep 10 && $WINE_PATH net start blueiris & /home/wineuser/check_process.sh
