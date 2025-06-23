#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi

---

SNAP_FILE="$1"

if [[ -z "$SNAP_FILE" ]]; then
    echo "Error: No snap.txt path provided as an argument."
    echo "Usage: sudo ./install_snap_packages.sh /path/to/snap.txt"
    exit 1
fi

if [[ ! -f "$SNAP_FILE" ]]; then
    echo "Error: snap.txt not found at '$SNAP_FILE'. Please ensure the path is correct."
    exit 1
fi

---

echo "Reading Snap packages from '$SNAP_FILE'..."

mapfile -t PACKAGES_TO_INSTALL < <(grep -vE "^\s*(#|$)" "$SNAP_FILE" | xargs -r -n 1)

if [ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]; then
    echo "No Snap packages found in '$SNAP_FILE' to install."
else
    echo "Attempting to install the following Snap packages:"
    for package in "${PACKAGES_TO_INSTALL[@]}"; do
        if snap install "$package" --classic; then
            echo "'$package' installed successfully."
        else
            echo "Warning: Failed to install '$package'. Please check the error message above for details. Continuing with other packages."
        fi
    done
    echo "---"
    echo "All specified Snap package installations finished."
fi