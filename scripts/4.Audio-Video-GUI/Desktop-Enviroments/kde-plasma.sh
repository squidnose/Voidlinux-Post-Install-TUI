#!/bin/bash
# Linux Bulk App Chooser (LBAC)
# https://codeberg.org/squidnose-code/Linux-Bulk-App-Chooser
#==================================== Configs ====================================
##Title Name
TITLE="Kde Plasma Installation Helper"
## Package list:
PACKAGES=(xorg wayland dbus NetworkManager python3-dbus kde-plasma kde-baseapps plasma-integration plasma-browser-integration plasma-wayland-protocols xdg-desktop-portal-kde kwalletmanager breeze spectacle ark 7zip-unrar kolourpaint krename filelight kdeconnect kcalc discover octoxbps kio-gdrive kio-extras ufw plasma-firewall flatpak-kcm korganizer kontact calendarsupport kdepim-addons kdepim-runtime akonadi-calendar akonadi-contacts akonadi-import-wizard kdegraphics-thumbnailers ffmpegthumbs ksystemlog clinfo  aha  fwupd wayland-utils)
## Manual list entries:
## "TAG" "DESCRIPTION" "OFF/ON"
MANUAL_OPTIONS=(
##Base dependencies
    "xorg"               "xorg server" ON
    "wayland"            "wayand compositor" ON
    "dbus"               "DBUS nessery" ON
    "NetworkManager"     "Network Management daemon" ON
    "python3-dbus"       "Usefull dependency for Eduroam" OFF
##Kde plasma Packages
    "kde-plasma"         "KDE plasma Meta Package" ON
    "kde-baseapps"       "Meta package: kate, khelpcenter, konsole" ON
    "plasma-integration" "Theme integration plugins for the Plasma workspaces" OFF
    "plasma-browser-integration"        "Integration of web browsers with the KDE Plasma 6 desktop" OFF
    "plasma-wayland-protocols"          "Plasma Specific Protocols for Wayland" OFF
    "xdg-desktop-portal-kde"            "Backend implementation for xdg-desktop-portal that is using Qt/KF6" OFF
    "kwalletmanager"      "KDE Wallet Management Tools" OFF
    "breeze"            "Breeze visual style for the Plasma Desktop" OFF
##Kde Apps
    "spectacle"         "KDE screenshot capture utility" OFF
    "ark"               "KDE Archiving Tool" OFF
    "7zip-unrar"        "File archiver with a high compression ratio - RAR support" OFF
    "kolourpaint"       "Free, easy-to-use paint program for KDE" OFF
    "krename"           "Powerful batch renamer for KDE" OFF
    "filelight"         "Interactive map that helps visualize disk usage on your computer" OFF
    "kdeconnect"        "Multi-platform app that allows your devices to communicate" OFF
    "kcalc"             "Simple and scientific calculator from KDE" OFF
    "discover"          "KDE resources management flatpak, plasma plugins" OFF
    "octoxbps"          "Voids Qt-based XBPS front-end" OFF
##Optional Tools for Plasma
    "kio-gdrive"         "KIO slave that enables access and edit Google Drive files" OFF
    "kio-extras"         "Additional KIO components" OFF
    "ufw"                "Uncomplicated Firewall" OFF
    "plasma-firewall"    "Control Panel for ufw (Uncomplicated Firewall)" OFF
    "flatpak-kcm"        "KDE Config Module for Flatpak Permissions" OFF
    "korganizer"         "Calendar and scheduling Program from KDE" OFF
    "kontact"            "KDE Personal Information Manager (PIM)" OFF
    "calendarsupport"    "Calendar support library from KDE" OFF
    "kdepim-addons"      "Addons for KDE PIM applications" OFF
    "kdepim-runtime"     "KDE PIM runtime applications/libraries" OFF
    "akonadi-calendar"   "Akonadi calendar integration For KDE PIM" OFF
    "akonadi-contacts"   "Libraries and daemons to implement Contact Management in Akonadi" OFF
    "akonadi-import-wizard"             "Import data from other mail clients to KMail" OFF
    "kdegraphics-thumbnailers"          "KDE Plasma 6 Thumbnailers for various graphics file formats" OFF
    "ffmpegthumbs"       "FFmpeg-based thumbnail creator for video files" OFF
    "ksystemlog"         "KDE System log viewer tool" OFF
##Info Utils for Plasma
    "clinfo"             "Prints all information about OpenCL in the system" OFF
    "aha"                "Converts SGR-colored Input to W3C conform HTML-Code (used in info center)" OFF
    "fwupd"              "Daemon to allow session software to update firmware" OFF
    "wayland-utils"      "Wayland utilities" OFF
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
