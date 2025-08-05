#!/bin/bash

# Script to optimize older Intel CPUs

# Define the kernel parameters to be added
KERNEL_PARAMS="mitigations=off nowatchdog cryptomgr.notests intel_idle.max_cstate=1 no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable"

# Check if the parameters are already set
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT=.*$KERNEL_PARAMS" /etc/default/grub; then
    echo "The kernel parameters are already set."
    read -p "Would you like to remove them? (y/n) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        # Restore the original GRUB configuration from backup
        echo "Restoring original GRUB configuration from backup..."
        sudo cp /etc/default/grub.backup /etc/default/grub

        # Update GRUB
        echo "Updating GRUB..."
        sudo update-grub

        echo "Parameters removed. Please reboot your system for changes to take effect."
    else
        echo "No changes made."
    fi
else
    echo "This script will apply the following kernel parameters:"
    echo "$KERNEL_PARAMS"

    read -p "Would you like to apply them? (y/n) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        # Back up the current GRUB config
        echo "Backing up current GRUB configuration..."
        sudo cp /etc/default/grub /etc/default/grub.backup

        # Modify GRUB_CMDLINE_LINUX_DEFAULT line
        echo "Modifying GRUB kernel parameters in file /etc/default/grub..."
        # Use a more robust sed command to append the parameters
        sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$KERNEL_PARAMS /" /etc/default/grub

        # Update GRUB
        echo "Updating GRUB..."
        sudo update-grub

        echo "Done. Please reboot your system for changes to take effect."
    else
        echo "No changes made."
    fi
fi
