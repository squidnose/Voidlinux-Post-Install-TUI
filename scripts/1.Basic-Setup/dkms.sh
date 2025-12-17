#!/bin/bash
echo "This script is for: DKMS(Important for Nvidia and Virtualbox) for voids default linux kernel. "
echo "If you choose to use diferent kernel, install the header package for it. Eg: linux6.15 and linux6.15-headers"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install -Syu linux-headers
