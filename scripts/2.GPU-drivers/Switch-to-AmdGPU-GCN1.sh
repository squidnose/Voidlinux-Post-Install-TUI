#!/bin/bash

# Script to enable AMDGPU driver for older GCN1 cards

echo "This script will enable AMDGPU for older GCN1 cards."
echo "This will disable VGA output from DVI-I adapters.(Is being worked on)"

# Back up the current GRUB config
echo "Backing up current GRUB configuration..."
sudo cp /etc/default/grub /etc/default/grub.backup

#Chek if the kernel parameters are allready set
if grep -q "amdgpu.si_support=1 radeon.si_support=0 amdgpu.cik_support=1 radeon.cik_support=0" "/etc/default/grub"; then
    echo "Kernel parameters already set. No changes."
else

# Modify GRUB_CMDLINE_LINUX_DEFAULT line
echo "Modifying GRUB kernel parameters in file /etc/default/grub..."
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="amdgpu.si_support=1 radeon.si_support=0 amdgpu.cik_support=1 radeon.cik_support=0 /' /etc/default/grub

# Update GRUB
echo "Updating GRUB..."
sudo update-grub

# Done
echo "Done. Please reboot your system for changes to take effect."
fi
