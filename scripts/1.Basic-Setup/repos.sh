#!/bin/bash
# Manage Repos on Voidlinux
#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

TITLE="Voidlinux Repo Manager"

#================  2 - XBPS - Query ================
#if whiptail --title "$TITLE" --yesno "Update System - RECCOMENDED!!!" $HEIGHT $WIDTH; then
#    echo "Synchronize and Update:"
#    sudo xbps-install -Syu
#fi
# nonfree
if xbps-query -l | grep -Eq void-repo-nonfree; then
    NON_FREE_STAT="Enabled"
else
    NON_FREE_STAT="Disabled"
fi

# multilib
if xbps-query -l | grep -Eq void-repo-multilib; then
    MULTILIB_STAT="Enabled"
else
    MULTILIB_STAT="Disabled"
fi

# multilib nonfree
if xbps-query -l | grep -Eq void-repo-nonfree; then
    MULTILIB_NON_FREE_STAT="Enabled"
else
    MULTILIB_NON_FREE_STAT="Disabled"
fi

#================  3 - Flatpak - Query ================
# Checks if flatpak and the flathub remote are installed
if command -v flatpak >/dev/null 2>&1; then
    FLATHUB="Flatpak Installed BUT flathub not enabled!"
    if flatpak remotes 2>/dev/null | grep -q "^flathub"; then
       FLATHUB="Enabled"
    fi
else
    FLATHUB="Disabled"
fi

if ! command -v flatpak >/dev/null 2>&1; then
   echo "Flatpak Not Installed"
fi


#================  4 - Install Commands ================

flathub()
{
sudo xbps-install -Syu flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

#================  5 - Main Menu ================
while true; do
    REPO=$(whiptail --title "$TITLE" --menu "Select SW repository to Manage:" \
    $HEIGHT $WIDTH $MENU_HEIGHT  \
        "void-repo-nonfree"          "Non FOSS SW - Nvidia, Broadcom... ($NON_FREE_STAT) " \
        "void-repo-multilib"         "32 bit SW - 32 bit gpu drivers... ($MULTILIB_STAT)" \
        "void-repo-multilib-nonfree" "Non FOSS 32 bit SW - Steam...     ($MULTILIB_NON_FREE_STAT)" \
        "flathub"                    "Flatpak apps                      ($FLATHUB)" \
        "x" "exit" \
    3>&1 1>&2 2>&3) || REPO="x"
    # If user preses x
    if [ "$REPO" == "x" ]; then
        exit 0
    fi
    # Operation
    REPO_OPERATION=$(whiptail --title "$TITLE" --menu "Choose:" \
    $HEIGHT $WIDTH $MENU_HEIGHT  \
        "Enable"  "$REPO" \
        "Disable" "$REPO" \
        "Cancel"  "Go Back" \
    3>&1 1>&2 2>&3)
    case $REPO in
        void-repo-nonfree)
            if [ "$REPO_OPERATION" == "Enable" ]; then
                sudo xbps-install -Su void-repo-nonfree
            elif [ "$REPO_OPERATION" == "Disable" ]; then
                sudo xbps-remove void-repo-nonfree
            fi
        ;;
        void-repo-multilib)
            if [ "$REPO_OPERATION" == "Enable" ]; then
                sudo xbps-install -Su void-repo-multilib
            elif [ "$REPO_OPERATION" == "Disable" ]; then
                sudo xbps-remove void-repo-multilib
            fi
        ;;
        void-repo-multilib-nonfree)
            if [ "$REPO_OPERATION" == "Enable" ]; then
                sudo xbps-install -Su void-repo-multilib-nonfree
            elif [ "$REPO_OPERATION" == "Disable" ]; then
                sudo xbps-remove void-repo-multilib-nonfree
            fi
        ;;
        flathub)
            if [ "$REPO_OPERATION" == "Enable" ]; then
                sudo xbps-install -Su flatpak
                flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            elif [ "$REPO_OPERATION" == "Disable" ]; then
                flatpak remote-delete flathub
                if whiptail --title "$TITLE" --yesno "Remove flatpak aswell?" $HEIGHT $WIDTH; then
                    sudo xbps-remove flatpak
                fi
            fi
        ;;
        *) exit 0 ;;
    esac
done
