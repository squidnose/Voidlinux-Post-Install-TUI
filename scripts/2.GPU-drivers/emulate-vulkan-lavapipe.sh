#!/bin/bash
echo "will not work wth propriaterry nvidia driver"
read -p "Press Enter to install Vulkan emulatoin for Non vulkan cards, CTRL+c to cancel"
sudo xbps-install -Sy mesa-vulkan-lavapipe
sudo xbps-install -Sy mesa-vulkan-lavapipe-32bit
