#!/bin/bash

#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

TITLE="Voidlinux Manintanace"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

#================  2 - Logs ================
# Log what happens in TUI
LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"

# Echo into terminal, then log into file (if logs are enabled )
echlog()
{
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}

#================  3 - Updates ================
Manual_Update()
{
while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose:" $HEIGHT $WIDTH $MENU_HEIGHT \
    "XBPS_update"       "Only update XBPS system packages" \
    "Flatpak_update"    "Only update flatpak Apps" \
    ".."                "Go Back" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    XBPS_update) sudo xbps-install -Su ;;
    Flatpak_update) flatpak update ;;
    *) return 0 ;;
    esac
done
} #Manual_Update()
vkpurge_tui()
{

# 1. Make kernel list
KERNEL_LIST=$(vkpurge list)

# 2. Check if there are any kernels to remove
if $KERNEL_LIST  >/dev/null 2>&1; then
    whiptail --title "vkpurge TUI" --msgbox "There seems to no left over kernels to remove.\n\nYour system has been well taken care of:)" $HEIGHT $WIDTH
    return 0
fi

# 3. Inform the user
whiptail --title "vkpurge TUI" --msgbox "This utility will list and allow you to remove old, unused Linux kernels managed by vkpurge.\nONLY RUN WHEN YOU ARE SURE THE CURENT KERNEL IS FUNCTIONAL!\n(To make sure, just reboot)." $HEIGHT $WIDTH

# 4. Ask to run vkpurge or not
if whiptail --title "vkpurge TUI" --yesno --defaultno "Remove the following kernels?\n\n${KERNEL_LIST}" \
$HEIGHT $WIDTH; then
    sudo vkpurge rm all
    if [ $? -eq 0 ]; then
            whiptail --title "Success" --msgbox \
            "Successfully removed all listed unused kernels. Rebooting may be required." $HEIGHT $WIDTH
    else
        whiptail --title "Error" --msgbox \
            "Failed to remove the kernels. Please check your permissions or connectivity." $HEIGHT $WIDTH
    fi
fi
}


#================  4 - Main Menu ================

while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose:" $HEIGHT $WIDTH $MENU_HEIGHT \
    "Update_ALL"        "Update using Topgrade (System, Apps, Firmware)" \
    "XBPS_clear"        "Clear xbps cache" \
    "Old_kernels"       "Remove unused kernels" \
    "Manual_Update"     "Select what part of your system to update" \
    ".."                 "Go Back" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    Update_ALL) bash "$SCRIPT_DIR/3.1-Update-System-Topgrade.sh" ;;
    XBPS_clear)
        if whiptail --title "$TITLE" --yesno --defaultno "Clear XBPS cache?" $HEIGHT $WIDTH; then
            sudo xbps-remove -yO
        fi
    ;;
    Old_kernels) vkpurge_tui ;;
    Manual_Update) Manual_Update ;;
    *) exit 0 ;;
    esac
done
