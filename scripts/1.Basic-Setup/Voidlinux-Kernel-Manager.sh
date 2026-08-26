#!/bin/bash
# Voidlinux Kernel Manager
## Install/Remove diferent kernels, based on what is avaliable in the package manager
## Set default kernel series (mainline or LTS)
## Pin the linux kernel to a specific version

#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

TITLE="Void Linux Kernel Manager"
#================  2 - Functions ================

# Echlog
LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"
echlog()
{
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}

kernel_query()
{
# kernel_query()
## Find out what kernels are avaliable in xbps
## Also find out wheather it is allready installed
## And if the installed kernel has the headers package installed (for DKMS funcion)

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

manual_kernel_selection()
{
# Debug:
echlog "List of Avaliable Kernels:"
kernel_query
while true; do
    # Create an array of items for whiptail --menu
    mapfile -t MENU_ITEMS_KERNELS < <(kernel_query)
    CHOSEN_KERNEL=$(whiptail --title "$TITLE" \
        --menu "Select a Linux Kernel series to manage:" \
        $HEIGHT $WIDTH $MENU_HEIGHT \
        "${MENU_ITEMS_KERNELS[@]}" \
    3>&1 1>&2 2>&3) || return 0

    # Check if user presses cancel
    [ $? -ne 0 ] && break
    # Debug:
    echo "Chosen $CHOSEN_KERNEL kernel to manage"

# Manage Kernel:
    CHOSEN_KERNEL_OPTION=$(whiptail --title "$TITLE" \
        --menu "You chose $CHOSEN_KERNEL, what would you like to do?" $HEIGHT $WIDTH $MENU_HEIGHT \
        "Install" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Remove" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Reconfigure" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Force_Reconfigure" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
        "Set_Default_As" "$CHOSEN_KERNEL and $CHOSEN_KERNEL-headers" \
    3>&1 1>&2 2>&3)

    case $CHOSEN_KERNEL_OPTION in
    Install) sudo xbps-install -Su $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Remove) sudo xbps-remove $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Reconfigure) sudo xbps-reconfigure $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Force_Reconfigure) sudo xbps-reconfigure --force $CHOSEN_KERNEL $CHOSEN_KERNEL-headers ;;
    Set_Default_As) set_default_kernel $CHOSEN_KERNEL ;;
    esac

done
return 0
} #manual_kernel_selection()

set_default_kernel()
{
local target_pkg="$1"
local linux_conf="/etc/xbps.d/virtualpkg-linux.conf"

# If no parameter was provided, open a whiptail selection menu
if [ -z "$target_pkg" ]; then
    target_pkg=$(whiptail --title "Set Default Kernel Series" \
        --menu "Select which kernel should map to the virtual 'linux' package:" \
        $HEIGHT $WIDTH $MENU_HEIGHT \
        "linux-mainline" "Latest mainline kernel series" \
        "linux-lts"      "Long-Term Support series" \
        "default"        "Reset to default configuration" \
        3>&1 1>&2 2>&3)

    # Exit if user cancelled or closed the dialog
    [ $? -ne 0 ] || [ -z "$target_pkg" ] && return 0
fi

if [ $target_pkg == "default" ]; then
    if whiptail --title "$TITLE" --yesno "Reset to default kernel configuration" $HEIGHT $WIDTH; then
        sudo rm "/etc/xbps.d/ignorepkg-linux.conf" #Just in case
        sudo rm "/etc/xbps.d/virtualpkg-linux.conf"
        sudo xbps-install -Su linux linux-headers
    fi
# Confirm before writing to /etc/xbps.d/
elif whiptail --title "$TITLE" --yesno \
"Set '$target_pkg' as the systems default kernel?\n\nThis will write to:\n$linux_conf" $HEIGHT $WIDTH; then

    # Write configuration safely using sudo tee
    printf "virtualpkg=linux:%s\nvirtualpkg=linux-headers:%s-headers\n" "$target_pkg" "$target_pkg" | sudo tee "$linux_conf" >/dev/null

    echlog "Updated $linux_conf -> virtualpkg mapped to $target_pkg"

#Reset the default kernel
sudo tee "/etc/xbps.d/ignorepkg-linux.conf" >/dev/null <<EOF
ignorepkg=linux
ignorepkg=linux-headers
EOF
    echo "===== Remove the Previous Kernel? ====="
    sudo xbps-remove linux linux-headers
    echo "===== Check if new kernel version matches: ====="
    sudo xbps-install linux linux-headers
    sudo rm "/etc/xbps.d/ignorepkg-linux.conf"

fi
} #set_default_kernel()

#================  3 - Main Menu ================
while true; do
    MENU_VKM_CHOICE=$(whiptail --title "$TITLE" --menu "Choose:" $HEIGHT $WIDTH $MENU_HEIGHT \
        "1" "Set default kernel series (LTS, Mainline)" \
        "2" "Manually select kernel version to manage" \
        "3" "Select Kernel Parameters" \
        "x" "Exit $TITLE" \
    3>&1 1>&2 2>&3)
    case $MENU_VKM_CHOICE in
    1) set_default_kernel ;;
    2) manual_kernel_selection ;;
    3) bash "$(dirname "$(realpath "$0")")/Grub-Kernel-Parameters/kernel-parameter-TUI-config.sh" ;;
    *)
    echlog "Exited $TITLE"
    exit 0 ;;
    esac

done


