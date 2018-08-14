#!/bin/sh

LOCAL_INSTALL=1
INSTALL_PATH=""


if [[ $LOCAL_INSTALL -eq 1 ]]; then
    INSTALL_PATH="/usr/local/"
fi

cp -frv lib  "$INSTALL_PATH"
cp -frv sbin "$INSTALL_PATH"
