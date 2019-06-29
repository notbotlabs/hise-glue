#!/bin/bash

echo "Setting up symbolic link (if necessary)" | cat >> /tmp/install-Log

if [[ -e /tmp/customSampleDirTmp ]]; then
    TMPDIR=`cat /tmp/customSampleDirTmp`
    ln -s $TMPDIR /tmp/Linked

    echo "Temporary folder linked to /tmp/Linked: $TMPDIR" | cat >> /tmp/install-Log
else
    echo "No symbolic link requested by user" | cat >> /tmp/install-Log
fi
