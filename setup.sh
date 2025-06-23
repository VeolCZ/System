#!/bin/bash

echo "Starting the automated Ubuntu setup..."

SETUP_DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p "$SETUP_DIR/scripts"

APT_FILE="$SETUP_DIR/apt.txt"
SNAP_FILE="$SETUP_DIR/snap.txt"
I3_CONFIG_FILE="$SETUP_DIR/i3_config.txt"

if [[ ! -f "$APT_FILE" ]]; then
    echo "Error: apt.txt not found at $APT_FILE. Please ensure it's in the setup directory."
    exit 1
fi
if [[ ! -f "$SNAP_FILE" ]]; then
    echo "Error: snap.txt not found at $SNAP_FILE. Please ensure it's in the setup directory."
    exit 1
fi
if [[ ! -f "$I3_CONFIG_FILE" ]]; then
    echo "Error: i3_config.txt not found at $I3_CONFIG_FILE. Please ensure it's in the setup directory."
    exit 1
fi

# --- Call individual setup scripts ---

echo "--- Running APT package installation ---"
sudo bash "$SETUP_DIR/scripts/install_apt_packages.sh" "$APT_FILE"
if [ $? -eq 0 ]; then
    echo "APT packages installed successfully."
else
    echo "Error installing APT packages. Please check the logs."
    exit 1
fi

echo "--- Running Snap package installation ---"
sudo bash "$SETUP_DIR/scripts/install_snap_packages.sh" "$SNAP_FILE"
if [ $? -eq 0 ]; then
    echo "Snap packages installed successfully."
else
    echo "Error installing Snap packages. Please check the logs."
    exit 1
fi

# echo "--- Setting up i3 configuration ---"
# bash "$SETUP_DIR/scripts/setup_i3.sh" "$I3_CONFIG_FILE"
# if [ $? -eq 0 ]; then
    # echo "i3 configuration set up successfully."
# else
    # echo "Error setting up i3 configuration. Please check the logs."
# fi

echo "--- Setting up dark theme ---"
sudo bash "$SETUP_DIR/scripts/setup_dark_theme.sh"
if [ $? -eq 0 ]; then
    echo "Dark theme set up successfully."
else
    echo "Error setting up dark theme. Please check the logs."
fi

echo "--- Setting up keyboard with keyd ---"
sudo bash "$SETUP_DIR/scripts/setup_keyd.sh"
if [ $? -eq 0 ]; then
    echo "Keyd keyboard setup complete."
    echo "A reboot might be necessary for keyd to fully take control of input devices."
else
    echo "Error setting up keyd. Please check the logs."
fi

echo "Ubuntu setup complete! You might need to reboot for all changes to take effect."