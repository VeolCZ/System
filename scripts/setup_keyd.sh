#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo privileges"
    exit 1
fi

echo "Setting up keyd configuration..."

mkdir -p /etc/keyd

cat << 'EOF' > /etc/keyd/default.conf
[ids]
*

[main]
capslock = overload(control, escape)
EOF

echo "Keyd configuration file created/updated at /etc/keyd/default.conf"

echo "Enabling and starting keyd service..."
systemctl daemon-reload
systemctl enable keyd
systemctl start keyd

if [ $? -eq 0 ]; then
    echo "Keyd service enabled and started."
else
    echo "Error enabling or starting keyd service. Please ensure keyd is installed."
    echo "You can find more information on installing keyd at: https://github.com/rvaiya/keyd"
fi

systemctl restart keyd
