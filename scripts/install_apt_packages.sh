#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi


APT_FILE="$1"

if [[ -z "$APT_FILE" ]]; then
    echo "Error: No apt.txt path provided as an argument."
    echo "Usage: sudo ./install_apt_packages.sh /path/to/apt.txt"
    exit 1
fi

if [[ ! -f "$APT_FILE" ]]; then
    echo "Error: apt.txt not found at '$APT_FILE'. Please ensure the path is correct."
    exit 1
fi


echo "Updating and upgrading APT packages..."
if ! apt update -y || ! apt upgrade -y; then
    echo "Error: Failed to update or upgrade APT package list. Please check your internet connection or repository settings."
    exit 1
fi


echo "Installing APT packages from '$APT_FILE'..."

if grep -vE "^\s*(#|$)" "$APT_FILE" | xargs -r sudo apt install -y; then
    echo "All specified APT packages from '$APT_FILE' installed successfully (or already installed)."
else
    echo "Error: Failed to install one or more APT packages. Please check the logs above for specific errors."
    exit 1
fi