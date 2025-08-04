#!/bin/bash
sudo xbps-install -Syu broadcom-wl-dkms broadcom-bt-firmware
sudo usermod -aG network
