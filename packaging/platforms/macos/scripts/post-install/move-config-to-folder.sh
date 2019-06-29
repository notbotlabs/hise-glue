#!/bin/bash

APP_LIBRARY_PATH="$HOME/Library/Application Support/Not Bot Labs/Sad By Design"

if [[ ! -d "$APP_LIBRARY_PATH" ]]; then
    mkdir -p "$APP_LIBRARY_PATH"
fi

if [[ ! -d "$APP_LIBRARY_PATH/User Presets" ]]; then
    mkdir -p "$APP_LIBRARY_PATH/User Presets"
fi

if [[ ! -d "$APP_LIBRARY/Extensions" ]]; then
    mkdir -p "$APP_LIBRARY_PATH/Extensions"
fi

if [[ ! -d /tmp/default-hise-config ]]; then
    exit 1;
else
    cp -r /tmp/default-hise-config/* "$APP_LIBRARY_PATH"
    rm -rf /tmp/default-hise-config
fi

chown $USER "$APP_LIBRARY_PATH"
