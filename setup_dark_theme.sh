#!/bin/bash

# Script to set up a full black/white theme for i3 with Nautilus (GTK 4) support

# Download nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

set -e

# Check if script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges"
    exit 1
fi

echo "Turning off screen saver"
xset s off

# The line to add
LINE='GTK_THEME="Adwaita-dark"'

# File to modify
FILE="/etc/environment"

# Check if the line already exists in the file
if grep -Fxq "$LINE" "$FILE"; then
    echo "GTK_THEME is already set to Adwaita-dark in $FILE"
else
    # Add the line to the file
    echo "$LINE" >> "$FILE"
    if [ $? -eq 0 ]; then
        echo "Successfully added GTK_THEME=Adwaita-dark to $FILE"
    else
        echo "Error: Failed to write to $FILE"
        exit 1
    fi
fi

exit 0