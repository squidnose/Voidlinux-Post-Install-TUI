#!/bin/bash
sudo xbps-install -Syu broadcom-wl-dkms broadcom-bt-firmware
sudo usermod -aG network "$USER"
#making a service file so that the driver will load
sudo mkdir -p /etc/sv/reload-wl
sudo tee /etc/sv/reload-wl/run >/dev/null <<'EOF'
#!/bin/sh
# Wait a few seconds to make sure everything is initialized
sleep 2
modprobe -r wl
modprobe wl
exit 0
EOF

sudo chmod +x /etc/sv/reload-wl/run
sudo ln -s /etc/sv/reload-wl /var/service/
#Test without reboot
sudo /etc/sv/reload-wl/run

lsmod | grep wl
nmcli dev status

