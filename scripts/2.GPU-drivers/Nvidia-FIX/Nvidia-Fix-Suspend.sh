#!/bin/bash
set -e

echo "=== NVIDIA Suspend Fix for Void Linux (elogind + zzz) ==="

# 1. Ensure elogind is installed
if ! command -v loginctl >/dev/null 2>&1; then
    echo "elogind is not installed. Installing..."
    sudo xbps-install -Sy elogind
else
    echo "elogind is already installed."
fi

# 2. Disable acpid if running
if sv status acpid >/dev/null 2>&1; then
    echo "Disabling acpid..."
    sudo sv down acpid || true
    sudo rm -f /var/service/acpid
else
    echo "acpid is not active."
fi

# 3. Enable elogind service
if [ ! -e /var/service/elogind ]; then
    echo "Enabling elogind..."
    sudo ln -s /etc/sv/elogind /var/service/
    sudo sv up elogind
else
    echo "elogind service already enabled."
fi

# 4. Backup elogind's NVIDIA sleep hook
HOOK_DIR="/usr/libexec/elogind/system-sleep"
BACKUP_DIR="/usr/libexec/elogind/backup"

if [ -f "$HOOK_DIR/nvidia.sh" ]; then
    echo "Backing up existing nvidia.sh sleep hook..."
    sudo mkdir -p "$BACKUP_DIR"
    sudo mv "$HOOK_DIR/nvidia.sh" "$BACKUP_DIR/"
else
    echo "No default nvidia.sh hook found (skipping backup)."
fi

# 5. Configure elogind sleep.conf
SLEEP_CONF="/etc/elogind/sleep.conf"
echo "Configuring $SLEEP_CONF..."

sudo mkdir -p /etc/elogind
sudo tee "$SLEEP_CONF" >/dev/null <<EOF
[Sleep]
AllowSuspend=yes
SuspendByUsing=/usr/bin/zzz
HibernateByUsing=/usr/bin/ZZZ
EOF

# 6. Reload elogind
echo "Reloading elogind..."
sudo loginctl reload

echo
echo " NVIDIA suspend fix applied."
echo " Please reboot your system for changes to take effect."
