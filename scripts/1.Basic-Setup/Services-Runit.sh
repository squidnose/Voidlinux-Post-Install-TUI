#!/bin/bash
#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

TITLE="Voidlinux HW Tester"
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

#================  3 - Functions ================
# TBD LOL:))))

#================  4 - Main Menu ================

while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose: TBD" $HEIGHT $WIDTH $MENU_HEIGHT \
    "overview"  "of curent services" \
    "add"       "Services" \
    "remove"    "Servcices" \
    Exit    "Back to the Main Menu" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    *) exit 0 ;;
    esac
done


# What services do we even want
## usbmuxd - Iphone
## avahi - Network discovry and Printers
##
