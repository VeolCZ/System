#!/bin/bash

I3_CONFIG_SOURCE="$1"

if [[ -z "$I3_CONFIG_SOURCE" ]]; then
    echo "Error: No i3_config.txt path provided as an argument."
    exit 1
fi

if [[ ! -f "$I3_CONFIG_SOURCE" ]]; then
    echo "Error: i3_config.txt not found at '$I3_CONFIG_SOURCE'. Please ensure the path is correct."
    exit 1
fi

echo "Setting up i3 configuration..."

mkdir -p "$HOME/.config/i3"

cp "$I3_CONFIG_SOURCE" "$HOME/.config/i3/config"

if [ $? -eq 0 ]; then
    echo "i3 configuration file copied to ~/.config/i3/config"
else
    echo "Error copying i3_config.txt. Please check permissions or if the file exists."
    exit 1
fi

echo "You might need to reload i3 (mod+Shift+r) for changes to take effect."