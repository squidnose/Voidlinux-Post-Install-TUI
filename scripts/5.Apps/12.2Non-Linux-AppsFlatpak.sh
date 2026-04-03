#!/bin/bash
# Linux Bulk App Chooser (LBAC)
# https://codeberg.org/squidnose-code/Linux-Bulk-App-Chooser
#==================================== Configs ====================================
##Title Name
TITLE="Non Linux Apps Flatpak"
## Package list:
PACKAGES=(net._86box._86Box)
## Manual list entries:
## "TAG" "DESCRIPTION" "OFF/ON"
MANUAL_OPTIONS=(
    "net._86box._86Box"         "86Box, run old OS and Programs in a emulator with good performance" OFF
)
## OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)

## Commands:
INSTALL="flatpak install"
REMOVE="flatpak remove"
REPAIR="flatpak repair"
SHOW_PERMISION="flatpak permission-show"
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
        --checklist "Choose applications to install/un-install/repair:" \
        25 75 15 \
        "${MANUAL_OPTIONS[@]}" \
        3>&1 1>&2 2>&3

}
#==================================== Main Menu ====================================
CHOICE=$(whiptail --title "$TITLE" --menu "Choose an installation mode:" \
    20 60 10 \
    1 "Install All" \
    2 "Manual Selection" \
    3 "Un-install selected" \
    4 "Repair Selected" \
    5 "Show Permissions" \
    3>&1 1>&2 2>&3)

case "$CHOICE" in
    1)
        echo "Installing All Packages: ${PACKAGES[*]}"
        $INSTALL "${PACKAGES[@]}"
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
        ## Repair Packages
        echo "Reconfigure Selected Packages: ${SELECTED_PACKAGES[*]}"
        $REPAIR ${SELECTED_PACKAGES[@]}
    ;;
    5)
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Show permissions for Packages
        echo "Permissions for Selected Packages: ${SELECTED_PACKAGES[*]}"
        $SHOW_PERMISION ${SELECTED_PACKAGES[@]}
        echo "If you get an error, please only select one..."
    ;;
    *)
        echo "Exiting."
        exit 0
        ;;
esac
#just in case:)
exit 0
