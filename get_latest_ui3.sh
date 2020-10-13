#!/bin/bash
LATEST=$(curl -s https://api.github.com/repos/bp2008/ui3/releases/latest | jq -r '.assets[].browser_download_url')
NAME=$(curl -s https://api.github.com/repos/bp2008/ui3/releases/latest | jq -r '.assets[].name')
cd /home/wineuser/prefix/drive_c/Program\ Files/Blue\ Iris\ 5/www || exit
curl -Ls "${LATEST}" > "${NAME}"
unzip -o "${NAME}"
