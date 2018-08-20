#!/bin/sh

LOCAL_INSTALL=1
INSTALL_PATH=""
DEPS="fio stress-ng"

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root/superuser!"
    exit 1
fi

if [ $LOCAL_INSTALL -eq 1 ]; then
    INSTALL_PATH="/usr/local/"
fi

echo "Installing Dependencies"
apt-get update
apt-get install -y $DEPS

cp -frv lib  "$INSTALL_PATH"
cp -frv sbin "$INSTALL_PATH"
