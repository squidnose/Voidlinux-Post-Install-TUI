#!/bin/bash
#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

#================  2 - Functinos ================
# kernel_query()
## Find out what kernels are avaliable in xbps
## Also find out wheather it is allready installed
## And if the installed kernel has the headers package installed (for DKMS funcion)

kernel_query()
{
# Fetch remote packages, filter for actual kernel versions, and sort them
xbps-query -Rs "linux*" | awk '$2 ~ /^linux[0-9]/ {print $2}' | cut -d'-' -f1 | uniq | sort -V | while read -r kernel; do

    # Clean up the name for display (e.g., linux6.12 -> 6.12)
    version_num=$(echo "$kernel" | sed 's/linux//')

    # Check if the kernel package is currently installed
    if xbps-query -c -s "$kernel" >/dev/null 2>&1; then
        status="[Only Kernel Installed]"
        # Check if the headers are installed aswell
        if xbps-query -c -s "${kernel}-headers" >/dev/null 2>&1; then
        status="[Kernel and Headers(DKMS) Installed]"
        fi
    # Check for the unlikely possibility that the system has headers but no kernel
    elif xbps-query -c -s "${kernel}-headers" >/dev/null 2>&1; then
        status="[!!!Headers Installed with no Kernel???]"
    else
        status="[Not Installed]"
    fi
    echo "$kernel"
    echo "$status "
done
}
# kernel_query()

#================  3 - Main Menu ================
# Debug:
echo "List of Avaliable Kernels:"
kernel_query
while true; do
    # Create an array of items for whiptail --menu
    mapfile -t MENU_ITEMS_KERNELS < <(kernel_query)
    CHOSEN_KERNEL=$(whiptail --title "Void Linux Kernel Manager" \
        --menu "Select a Linux Kernel series to manage:" \
        $HEIGHT $WIDTH $MENU_HEIGHT \
        "${MENU_ITEMS_KERNELS[@]}" \
    3>&1 1>&2 2>&3)

    # Check if user presses cancel
    [ $? -ne 0 ] && break
    # Debug:
    echo "Chosen $CHOSEN_KERNEL kernel to manage"

# Manage Kernel:
    CHOSEN_KERNEL_OPTION=$(whiptail --title "Void Linux Kernel Manager" \
        --menu "You chose $CHOSEN_KERNEL, what would you like to do?" $HEIGHT $WIDTH $MENU_HEIGHT \
        "Install" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Remove" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Reconfigure" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Force_Reconfigure" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
    3>&1 1>&2 2>&3)

    case $CHOSEN_KERNEL_OPTION in
    Install) sudo xbps-install -Su $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Remove) sudo xbps-remove $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Reconfigure) sudo xbps-reconfigure $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Force_Reconfigure) sudo xbps-reconfigure --force $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    esac

done
