#!/bin/bash
# Linux Bulk App Chooser (LBAC)
# https://codeberg.org/squidnose-code/Linux-Bulk-App-Chooser
set -euo pipefail
##Prevents silent failure

#==================================== Configs ====================================
##Title Name
TITLE="XFCE4 Desktop Installation Helper"
## Package list:
PACKAGES=(xorg wayland dbus NetworkManager labwc python3-dbus lightdm lightdm-gtk-greeter-settings xfce4 xfce4-panel-profiles xfce4-plugins xfce4-datetime-plugin xfce4-dict xfce4-docklike-plugin xfce4-screenshooter xfce4-taskmanager ristretto thunar-archive-plugin xarchiver thunar-volman thunar-media-tags-plugin xdg-user-dirs-gtk xdg-desktop-portal-gtk xdg-utils parole blueman fontmanager gcolor3 kdeconnect octoxbps ufw clinfo fwupd wayland-utils)
## Manual list entries:
## "TAG" "DESCRIPTION" "OFF/ON"
MANUAL_OPTIONS=(
##Base dependencies
    "xorg"               "X.org meta-package" ON
    "wayland"            "Core Wayland window system code and protocol" ON
    "dbus"               "Message bus system (Good to have)" ON
    "NetworkManager"     "Network Management daemon" ON
    "labwc"              "Wayland window-stacking compositor (For wayland support)" OFF
    "python3-dbus"       "D-Bus Python3 bindings(Usefull for Eduroam)" OFF

## LightDM
    "lightdm"                       "Light Display Manager (Login Screen)" ON
    "lightdm-gtk-greeter-settings"  "Settings editor for LightDM GTK+ Greeter" ON

## XFCE4
    "xfce4"                     "XFCE meta-package for Void Linux" ON
    "xfce4-panel-profiles"      "Simple application to manage Xfce panel layouts" ON
    "xfce4-plugins"             "Plugins for the Xfce4 Desktop Environment" ON
    "xfce4-datetime-plugin"     "Date and time display plugin for the Xfce panel" ON
    "xfce4-dict"                "Dictionary plugin for the Xfce panel" ON
    "xfce4-docklike-plugin"     "Modern, minimalist taskbar for Xfce" ON
    "xfce4-screenshooter"       "Plugin that makes screenshots for the Xfce panel" ON
    "xfce4-taskmanager"         "XFCE task manager plugin" ON
    "ristretto"                 "Picture-viewer for the Xfce desktop environment" OFF
    "xfce-polkit"               "Simple PolicyKit authentication agent for XFCE" ON

## Thunar
    "thunar-archive-plugin"     "Create and extract archives in Thunar" OFF
    "xarchiver"                 "Lightweight desktop independent archive manager" OFF
    "thunar-volman"             "Thunar Volume Manager" OFF
    "thunar-media-tags-plugin"  "Adds special features for media files to the Thunar File Manager" OFF

## XDG
    "xdg-user-dirs-gtk"         "GTK+ tool to help manage user directories" ON
    "xdg-desktop-portal-gtk"    "Portal backend service for Flatpak using GTK+" ON
    "xdg-utils"                 "Tools to assist applications with various desktop integration tasks" ON

##Optional Tools
    "parole"            "Modern simple media player" OFF
    "blueman"           "GTK+ Bluetooth Manager" OFF
    "fontmanager"       "Font-manager is a simple font management tool for GTK+ environments" OFF
    "gcolor3"           "Simple GTK+2 color selector" OFF
    "kdeconnect"        "Multi-platform app that allows your devices to communicate" OFF
    "octoxbps"          "Voids Qt-based XBPS front-end" OFF
    "ufw"               "Uncomplicated Firewall" OFF

##Info Utils
    "clinfo"             "Prints all information about OpenCL in the system" OFF
    "fwupd"              "Daemon to allow session software to update firmware" OFF
    "wayland-utils"      "Wayland utilities" OFF
)
## OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)

## Commands:
INSTALL="sudo xbps-install -Su"
REMOVE="sudo xbps-remove"
RECONFIGURE="sudo xbps-reconfigure"
FORCE_RECONFIGURE="sudo xbps-reconfigure --force"
## Logfiles
LOGFILE_DIR="$HOME/.local/state/Linux-Bulk-App-Chooser"
LOGFILE_LOG="$HOME/.local/state/Linux-Bulk-App-Chooser/installed-packages.log"
LOGGING=1   # enabled by default

#============================ Logging ============================
while getopts "d" opt; do
    case "$opt" in
        d) LOGGING=0 ;;
        *)
        exit 1
        echo "Invalid option"
        ;;
    esac
done

# Create log directory only if logging is enabled
if [ "$LOGGING" -eq 1 ]; then
    mkdir -p "$LOGFILE_DIR"
fi

# Echo + optional log
# echolog either makes a log or only echos into terminal
echlog() {
    local msg="$*"
    echo "$msg"

    if [ "$LOGGING" -eq 1 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE_LOG"
    fi
}

echlog "========== $TITLE LBAC Ran =========="

#============================ Term Size============================
## Detect terminal size
### incase tput is not found, sets to fixed value
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT  ))
WIDTH=$(( TERM_WIDTH  ))
MENU_HEIGHT=$(( HEIGHT - 10 ))
### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu

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
whiptail --title "$TITLE" --msgbox "$PACKAGE_LIST" $HEIGHT $WIDTH

#==================================== Funtions ====================================
manual_selection_menu() {
    whiptail --title "Manual Package Selection for $TITLE" --checklist "Choose applications to install/un-install/reconfigure:" \
    $HEIGHT $WIDTH $MENU_HEIGHT \
    "${MANUAL_OPTIONS[@]}" \
    3>&1 1>&2 2>&3

}

exited() #Exit 0 with a echo debug notice
{
    echlog "exited out of $TITLE LBAC "
    echlog "================================================================"
    exit 0
}

#==================================== Main Menu ====================================
while true; do
    SELECTED_PACKAGES="" #Reset selected packages
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose an installation mode:" $HEIGHT $WIDTH $MENU_HEIGHT \
    1 "Install All" \
    2 "Manual Selection" \
    3 "Un-install selected" \
    4 "Reconfigure Selected" \
    5 "Force Reconfigure" \
    x "exit" \
    3>&1 1>&2 2>&3)

    case "$CHOICE" in
    1)
        echlog "Installing All Packages: ${PACKAGES[*]}"
        $INSTALL "${PACKAGES[@]}"
        ;;
    2)
        RAW=$(manual_selection_menu) || continue
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
        $INSTALL "${SELECTED_PACKAGES[@]}"
        ;;
    3)
        RAW=$(manual_selection_menu) || continue
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Remove Packages
        echlog "Removing Selected Packages: ${SELECTED_PACKAGES[*]}"
        $REMOVE ${SELECTED_PACKAGES[@]}
        ;;
    4)
        RAW=$(manual_selection_menu) || continue
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Reconfigures Packages
        echo "Reconfiguring Selected Packages: ${SELECTED_PACKAGES[*]}"
        $RECONFIGURE ${SELECTED_PACKAGES[@]}
        ;;
    5)
        RAW=$(manual_selection_menu) || continue
        RAW=${RAW//\"/}
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Forcefully Reconfigures Packages
        echlog "Forcefully Reconfiguring Selected Packages: ${SELECTED_PACKAGES[*]}"
        $FORCE_RECONFIGURE ${SELECTED_PACKAGES[@]}
        ;;
    x) exited ;;
    *) exited ;;
    esac || exited
done || exited
#just in case:)
exited
