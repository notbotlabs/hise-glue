#!/bin/bash

echo "POST INSTALL SCRIPT" | cat >> /tmp/install-Log

APP_LIBRARY_PATH="$HOME/Library/Application Support/Not Bot Labs/Sad By Design"
if [[ -e /tmp/customSampleDir ]]; then
    dest=`cat /tmp/customSampleDir`
else
    dest="$APP_LIBRARY_PATH"
fi

if [[ ! -d "$APP_LIBRARY_PATH" ]]; then
    mkdir -p "$APP_LIBRARY_PATH"
fi

echo "Moving Samples directory to folder: $dest" | cat >> /tmp/install-Log
if [[ -d /tmp/Linked/Samples ]]; then
    mv /tmp/Linked/Samples "$dest"
else
    echo "No samples folder fouund." | cat >> /tmp/install-Log
fi

echo "Setting up user ownership permissions" | cat >> /tmp/install-Log

chown -R $USER "$dest/Samples"
chown -R $USER "$APP_LIBRARY_PATH/.."

printf "%s" "$dest/Samples" > "$APP_LIBRARY_PATH/LinkOSX"

echo "Link location set: " >> /tmp/install-Log
cat "$APP_LIBRARY_PATH/LinkOSX" | cat >> /tmp/install-Log
echo "" >> /tmp/install-Log

#DEBUG=1

if [[ $DEBUG ]]; then
    echo "Saving all the details for you in /tmp/install-log"
else
    rm /tmp/install-Log

    if [[ -e /tmp/customSampleDir ]]; then
        rm /tmp/customSampleDir
    fi

    if [[ -e /tmp/customSampleDirTmp ]]; then
        rm /tmp/customSampleDirTmp
    fi

    if [[ -L /tmp/Linked ]]; then
        echo "Removing /tmp/Linked symlink" | cat >> /tmp/install-Log
        rm /tmp/Linked
    else
        if [[ -d /tmp/Linked ]]; then
            echo "Removing /tmp/Linked folder" | cat >> /tmp/install-Log
            rm -rf /tmp/Linked
        fi
    fi

    echo "Removed all temporary files"
fi
