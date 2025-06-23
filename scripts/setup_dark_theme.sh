#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges"
    exit 1
fi

# Download nvm
echo "Downloading nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

echo "Turning off screen saver"
xset s off

LINE='GTK_THEME="Adwaita-dark"'

FILE="/etc/environment"

if grep -Fxq "$LINE" "$FILE"; then
    echo "GTK_THEME is already set to Adwaita-dark in $FILE"
else
    echo "$LINE" >> "$FILE"
    if [ $? -eq 0 ]; then
        echo "Successfully added GTK_THEME=Adwaita-dark to $FILE"
    else
        echo "Error: Failed to write to $FILE"
        exit 1
    fi
fi

exit 0