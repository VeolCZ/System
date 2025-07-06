#!/bin/bash

if ! command -v tmux &> /dev/null; then
    echo "tmux is not installed. Please install tmux first (e.g., sudo apt install tmux or sudo dnf install tmux)."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git first (e.g., sudo apt install git or sudo dnf install git)."
    exit 1
fi

echo "Dependencies found."

# --- 2. Install TPM (Tmux Plugin Manager) ---
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "TPM installed."
else
    echo "TPM already exists. Skipping installation."
fi

# --- 3. Configure .tmux.conf ---
TMUX_CONF="$HOME/.tmux.conf"
echo "Configuring $TMUX_CONF..."

# Create .tmux.conf if it doesn't exist
if [ ! -f "$TMUX_CONF" ]; then
    touch "$TMUX_CONF"
    echo "# Tmux configuration file" >> "$TMUX_CONF"
    echo "Created new $TMUX_CONF."
fi

# Add plugin list if not already present
if ! grep -q "set -g @plugin 'tmux-plugins/tmux-resurrect'" "$TMUX_CONF"; then
    echo "" >> "$TMUX_CONF" # Add a newline for separation
    echo "# Tmux Plugin Manager (TPM) plugins" >> "$TMUX_CONF"
    echo "set -g @plugin 'tmux-plugins/tpm'" >> "$TMUX_CONF"
    echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> "$TMUX_CONF"
    echo "set -g @plugin 'tmux-plugins/tmux-continuum'" >> "$TMUX_CONF"
    echo "Added tmux-resurrect and tmux-continuum to plugin list."
else
    echo "tmux-resurrect and tmux-continuum already in plugin list. Skipping."
fi

# Add continuum auto-restore if not already present
if ! grep -q "set -g @continuum-restore 'on'" "$TMUX_CONF"; then
    echo "set -g @continuum-restore 'on'" >> "$TMUX_CONF"
    echo "Added auto-restore configuration for tmux-continuum."
else
    echo "Auto-restore configuration already present. Skipping."
fi

# Add TPM run command at the very end of the file, ensuring it's not duplicated
if ! grep -q "run '$TPM_DIR/tpm'" "$TMUX_CONF"; then
    echo "" >> "$TMUX_CONF" # Add a newline for separation
    echo "# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)" >> "$TMUX_CONF"
    echo "run '$TPM_DIR/tpm'" >> "$TMUX_CONF"
    echo "Added TPM run command to $TMUX_CONF."
else
    echo "TPM run command already present. Skipping."
fi

echo "$TMUX_CONF configuration complete."

# --- 4. Final Instructions ---
echo ""
echo "--- Setup Complete! ---"
echo ""
echo "To finalize the installation and enable persistent sessions, please do the following:"
echo "1. Start a new tmux session or re-source your .tmux.conf if you're already in one:"
echo "   - If you're NOT in a tmux session: Just type 'tmux' to start a new session."
echo "   - If you ARE in a tmux session: Type 'tmux source $TMUX_CONF' (or your prefix + : and then 'source-file ~/.tmux.conf')."
echo ""
echo "2. Once in a tmux session, press your tmux prefix (default: Ctrl-b, often Ctrl-a) followed by 'I' (capital 'i' as in Install)."
echo "   - You should see messages indicating the plugins are being downloaded and sourced."
echo ""
echo "Your tmux sessions will now be automatically saved and restored across reboots!"
echo "You can manually save with prefix + Ctrl-s and manually restore with prefix + Ctrl-r."
echo "Enjoy persistent tmux sessions!"