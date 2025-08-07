#!/bin/bash
sudo xbps-install -Syu broadcom-wl-dkms broadcom-bt-firmware
sudo usermod -aG network "$USER"
#making a rc file to start on boot
sudo mkdir -p /etc/rc.local.d/
sudo tee /etc/rc.local.d/reload-wl.sh >/dev/null <<'EOF'
#!/bin/sh
# Wait a few seconds to make sure everything is initialized
sleep 2
modprobe -r wl
modprobe wl
exit 0
EOF

sudo chmod +x /etc/rc.local.d/reload-wl.sh
sudo tee /etc/rc.local.d/reload-wl.sh >/dev/null <<'EOF'
./etc/rc.local.d/reload-wl.sh
EOF

#Test without reboot
sudo /etc/rc.local.d/reload-wl.sh
lsmod | grep wl
nmcli dev status

