#!/bin/bash
echo "Installiing Bluetooth related deps: bluez bluez-alsa libspa-bluetooth"
sudo xbps-install -Syu bluez bluez-alsa libspa-bluetooth
echo "Adding user to bluetooth group"
sudo usermod -aG bluetooth $USER
echo "enabling bluetooth serice"
sudo ln -s /etc/sv/bluetoothd /var/service/
