#!/bin/bash
sudo xbps-install -Syu broadcom-wl-dkms broadcom-bt-firmware
sudo usermod -aG network "$USER"

echo"enabling wl..."
sudo modprobe -r wl
sleep 5
sudo modprobe wl

echo"Enableed broadcom drivers once"
echo"After reboot run BCM-WL-FIX.desktop"


