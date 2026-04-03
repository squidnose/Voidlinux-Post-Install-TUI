#!/bin/bash
# Linux Bulk App Chooser (LBAC)
# https://codeberg.org/squidnose-code/Linux-Bulk-App-Chooser
#==================================== Configs ====================================
##Title Name
TITLE="Phone Integration XBPS"
## Package list:
PACKAGES=(android-tools android-file-transfer-linux android-file-transfer-linux-cli android-udev-rules ifuse kdeconnect)
## Manual list entries:
## "TAG" "DESCRIPTION" "OFF/ON"
MANUAL_OPTIONS=(
    "android-tools"                     "Android platform tools (adb and fastboot)" OFF
    "android-file-transfer-linux"       "Android File Transfer for Linux" OFF
    "android-file-transfer-linux-cli"   "Android File Transfer for Linux - cli tools" OFF
    "android-udev-rules"                "Android udev rules list aimed to be the most comprehensive on the net" OFF
    "ifuse"                             "FUSE filesystem to access the contents of an iPhone or iPod Touch" OFF
    "kdeconnect"                        "Multi-platform app that allows your devices to communicate from KDE" OFF
)
## OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)

## Commands:
INSTALL="sudo xbps-install -Su"
REMOVE="sudo xbps-remove"
RECONFIGURE="sudo xbps-reconfigure"
FORCE_RECONFIGURE="sudo xbps-reconfigure --force"
#==================================== Show Package List ====================================
## Build a readable list for whiptail
PACKAGE_LIST="Available Packages:\n\n"

i=0 ##Index helper
while [ $i -lt ${#MANUAL_OPTIONS[@]} ]; do
##MANUAL_OPTIONS Now serves as the number of elements in the array
##-lt is less than
    NAME="${MANUAL_OPTIONS[$i]}"
    DESC="${MANUAL_OPTIONS[$i+1]}"

    PACKAGE_LIST+="$NAME  -  $DESC\n"

    i=$((i+3)) ##is set to 3 because each line has 3 items
done

## Display the message box
whiptail --title "$TITLE" --msgbox "$PACKAGE_LIST" 30 80

#==================================== Funtions ====================================
manual_selection_menu() {
    whiptail --title "Manual Package Selection for $TITLE" \
        --checklist "Choose applications to install/un-install/reconfigure:" \
        25 110 15 \
        "${MANUAL_OPTIONS[@]}" \
        3>&1 1>&2 2>&3

}
optional_script() {
if whiptail --title "$TITLE" --yesno "Add yourself to the Dialout group(For ADB)" 15 60; then
    sudo usermod -aG dialout $USER
    echo "Added user $USER to dialout group"
fi

if whiptail --title "$TITLE" --yesno "If you are using UFW, do you wish to allow kdeconnect?" 15 60; then
    sudo ufw allow 1714:1764/udp
    sudo ufw allow 1714:1764/tcp
    sudo ufw reload
    echo "Added rules to UFW for Kde Connect"
    echo "You will need to restart to apply"
fi
}
#==================================== Main Menu ====================================
CHOICE=$(whiptail --title "$TITLE" --menu "Choose an installation mode:" \
    20 60 10 \
    1 "Install All" \
    2 "Manual Selection" \
    3 "Un-install selected" \
    4 "Reconfigure Selected" \
    5 "Force Reconfigure" \
    3>&1 1>&2 2>&3)

case "$CHOICE" in
    1)
        echo "Installing All Packages: ${PACKAGES[*]}"
        $INSTALL "${PACKAGES[@]}"
        optional_script
        ;;
    2)
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        ## The RAW output has " that package managers dont like
        ## The following commands remove quotes and convert into clean array
        RAW=${RAW//\"/}
        ## for reference: ${RAW//pattern/replacement}
        ## explanation:
            ### // replace for all occurrences
            ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "

        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Install Packages
        echo "Installing Selected Packages: ${SELECTED_PACKAGES[*]}"
        $INSTALL "${SELECTED_PACKAGES[@]}"
        optional_script
        ;;
    3)
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Remove Packages
        echo "Removing Selected Packages: ${SELECTED_PACKAGES[*]}"
        $REMOVE ${SELECTED_PACKAGES[@]}
        ;;
    4)
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Reconfigures Packages
        echo "Reconfiguring Selected Packages: ${SELECTED_PACKAGES[*]}"
        $RECONFIGURE ${SELECTED_PACKAGES[@]}
    ;;
    5)
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Forcefully Reconfigures Packages
        echo "Forcefully Reconfiguring Selected Packages: ${SELECTED_PACKAGES[*]}"
        $FORCE_RECONFIGURE ${SELECTED_PACKAGES[@]}
    ;;
    *)
        echo "Exiting."
        exit 0
        ;;
esac
#just in case:)
exit 0
