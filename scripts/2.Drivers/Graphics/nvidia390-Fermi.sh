#!/bin/bash
#============================ Term Size============================
## Detect terminal size
### incase tput is not found, sets to fixed value
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu

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

#==================================== Main Script ====================================
TITLE="NVIDIA Fermi cards (Geforce 400/500) - Driver Installer"
# Run VKpurge before install
if whiptail --title "$TITLE" --yesno "Remove unsed kernels?\n\nThis is Highly reccomended\n\nThis will speed-up the install procces." $HEIGHT $WIDTH; then
    echo "Searching and removing old unused kernels..."
    sudo vkpurge rm all
else
    echlog "Skipping kernel removal in nvidia390 installer."
fi

PACKAGES=(nvidia390 nvidia390-opencl nvidia390-libs-32bit nvidia390-gtklibs-32bit nvidia390-opencl-32bit)
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "nvidia390"               "NVIDIA drivers (GeForce 400, 500 series) - Libraries and Utilities" ON
    "nvidia390-opencl"        "NVIDIA drivers (GeForce 400, 500 series) - OpenCL implementation" ON
    "nvidia390-libs-32bit"    "NVIDIA drivers (GeForce 400, 500 series) - common libraries (32bit)" ON
    "nvidia390-gtklibs-32bit" "NVIDIA drivers (GeForce 400, 500 series) - GTK+ libraries (32bit)" ON
    "nvidia390-opencl-32bit"  "NVIDIA drivers (GeForce 400, 500 series) - OpenCL implementation (32bit)" ON
)

RAW=$( whiptail --title "$TITLE" --checklist "Do you wish to install all these driver packages?" \
    $HEIGHT $WIDTH $MENU_HEIGHT "${MANUAL_OPTIONS[@]}" \
    3>&1 1>&2 2>&3) || exit 0
## The RAW output has " that package managers dont like
## The following commands remove quotes and convert into clean array
RAW=${RAW//\"/}
## for reference: ${RAW//pattern/replacement}
## explanation:
    ### // replace for all occurrences
    ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "

read -r -a SELECTED_PACKAGES <<< "$RAW"
## Install Packages
echlog "Installing Selected Packages: ${SELECTED_PACKAGES[*]}"
sudo xbps-install -Syu "${SELECTED_PACKAGES[@]}"


whiptail --title "$TITLE" --msgbox "! Nvidia390 driver may have issues with kernels newer than 6.1 ! \n\nRun Voidlinux-Kernel-Manager and set your systems kernel to linux6.1" $HEIGHT $WIDTH

exit 0
