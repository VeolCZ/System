https://github.com/rvaiya/keyd

Configure keyd:
Create or edit the keyd configuration file at /etc/keyd/default.conf (you'll need sudo to edit this file). Add the following:

[ids]
*

[main]
capslock = overload(control, escape)

    [ids] and *: This section applies the mappings to all keyboards.

    [main]: This section defines the main layer of keybindings.

    capslock = overload(control, escape): This is the magic line. The overload function tells keyd to make the capslock key act as control when held (or used as a modifier) and send escape when tapped and released on its own.

Enable and Start the keyd Service:
After saving the configuration file, enable and start the keyd systemd service:

sudo systemctl daemon-reload
sudo systemctl enable keyd
sudo systemctl start keyd

If keyd was already running, you might need to restart it to apply the new configuration:

sudo systemctl restart keyd

A reboot might sometimes be necessary for keyd to fully take control of the input devices.

Important Note for keyd:
keyd typically takes exclusive control of the keyboard device(s) it manages. This means that X11-based keyboard configuration tools like xmodmap and setxkbmap might no longer affect the keyboard that keyd is controlling. If you have other X11 keyboard customizations, you would ideally migrate them to keyd's configuration format for consistency.
