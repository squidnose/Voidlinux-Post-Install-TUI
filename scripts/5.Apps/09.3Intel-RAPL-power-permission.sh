#!/bin/bash
set -euo pipefail
if whiptail --title "Intel RAPL permissions" --yesno "Do you wish to add permissions to Intel-rapl powercap, makes power readout not require root password." 15 60; then
sudo mkdir -p /etc/udev/rules.d/
UDEV_RULE="/etc/udev/rules.d/99-rapl.rules"

cat <<'EOF' | sudo tee "$UDEV_RULE" >/dev/null
# Fix Intel RAPL permissions
SUBSYSTEM=="powercap", RUN+="/bin/sh -c 'for f in /sys/devices/virtual/powercap/intel-rapl/*/energy_uj; do chmod 444 \"$f\"; done'"
EOF

# Reload Udev
sudo udevadm control --reload
sudo udevadm trigger
fi
exit 0
