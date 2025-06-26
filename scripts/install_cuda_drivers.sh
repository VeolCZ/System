#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi

echo "Starting CUDA driver installation process..."

echo "Installing gcc..."
if apt install gcc -y; then
    echo "gcc installed successfully."
else
    echo "Error: Failed to install gcc. Please check your internet connection or repository settings."
    exit 1
fi

echo "Installing ubuntu-drivers-common..."
if apt install ubuntu-drivers-common -y; then
    echo "ubuntu-drivers-common installed successfully."
else
    echo "Error: Failed to install ubuntu-drivers-common. Please check your internet connection or repository settings."
    exit 1
fi

echo "Detecting recommended NVIDIA drivers using ubuntu-drivers devices..."
if ubuntu-drivers devices; then
    echo "Driver detection complete."
else
    echo "Warning: Failed to detect NVIDIA devices or recommended drivers. Proceeding with autoinstall anyway."
fi

echo "Attempting to autoinstall recommended NVIDIA drivers..."
if ubuntu-drivers autoinstall; then
    echo "Recommended NVIDIA drivers installed successfully."
else
    echo "Error: Failed to autoinstall NVIDIA drivers. Please check the logs above for details."
    echo "You may need to manually install drivers or resolve conflicts. More info: https://ubuntu.com/blog/install-nvidia-drivers"
    exit 1
fi

echo "Installing NVIDIA CUDA Toolkit..."
if apt install nvidia-cuda-toolkit -y; then
    echo "NVIDIA CUDA Toolkit installed successfully."
else
    echo "Error: Failed to install NVIDIA CUDA Toolkit. Please check your internet connection or repository settings."
    echo "You can find more information at: https://developer.nvidia.com/cuda-downloads"
    exit 1
fi

echo "CUDA driver and toolkit installation complete."
echo "A reboot is highly recommended for the changes to take full effect."