#!/bin/bash
# Linux Bulk App Chooser (LBAC)
# https://codeberg.org/squidnose-code/Linux-Bulk-App-Chooser
set -euo pipefail
##Prevents silent failure

#==================================== Configs ====================================
# CONFIGIRE THIS PART:

##Title Name
TITLE="Terminal Utils"
## Package list:
PACKAGES=(fastfetch nerd-fonts-symbols-ttf htop tmux btop nano lazygit wget curl fuse-exfat ntfs-3g nvme-cli smartmontools parted cmatrix oneko cowsay espeak fortune-mod-void )
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    #Info
    "fastfetch"         "System information fetching tool(Like Neofetch)" OFF
    "nerd-fonts-symbols-ttf"    "Iconic font aggregator collection - TTF symbols-only font(For fastfetch)" OFF
    "htop"              "Interactive process viewer" OFF
    "btop"              "Monitor of resources" OFF
    "tmux"              "Terminal Multiplexer (Detachable Terminal Windows)" OFF
    "nano"              "GNU nano text editor" OFF
    #Download
    "lazygit"           "Simple terminal UI for git commands" OFF
    "wget"              "GNU wget download utility" OFF
    "curl"              "Client that groks URLs" OFF
    #Disk
    "fuse-exfat"        "Free exFAT file system implementation" OFF
    "ntfs-3g"           "Stable Read/Write NTFS Driver in userspace" OFF
    "nvme-cli"          "NVMe management command line interface" OFF
    "smartmontools"     "S.M.A.R.T Monitoring Tools" OFF
    "parted"            "GNU Parted disk partition resizing program" OFF
    #Fun
    "cmatrix"           "Simulates the display from The Matrix" OFF
    "oneko"             "Cat that chases around your cursor(Xorg)" OFF
    "cowsay"            "Configurable speaking/thinking cow (and a bit more)" OFF
    "espeak-ng"         "Text to Speech engine" OFF
    "fortune-mod-void"  "Quotes from #xbps and other void related stuff" OFF
)
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
    echlog "========================================="
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
