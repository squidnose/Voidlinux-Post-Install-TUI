#!/bin/bash
# Setup-Wizard for Voidlinux Post Install TUI

set -e

#==================================== Variables ====================================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
# set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

# SCRIPT_DIR should point to the base directory containing your numbered script folders.
SCRIPT_DIR="$(dirname "$(realpath "$0")")/scripts"

#Colors added for feature parity
export NEWT_COLORS_FILE="$HOME/.local/state/VOID-TUI/colors.conf"

# Title
TITLE="Void Linux Post-Install Wizard"
BACKTITLE="Void Linux Streamlined Setup"

#==================================== Functions ====================================
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

# Update XBPS
if whiptail --title "$TITLE" --yesno \
"Update XBPS?\nThis is reccomended for SW to install properly." $HEIGHT $WIDTH; then
    sudo xbps-install -Syu xbps
    echlog "Updated XBPS"
else
    echlog "Did not update XBPS, this may cause issues!!!"
fi

# Drivers menu 4
drivers()
{
while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose" $HEIGHT $WIDTH $MENU_HEIGHT \
    "GPU-Auto"      "Automatically Detect and Install GPU drivers" \
    "Broadcom"      "Setup Broadcom WiFi+Bluetooth" \
    "Realtek"       "Setup Realtek WiFi drivers(Limited HW)" \
    "Bluetooth"     "Setup Bluetooth Support (Universal)" \
    "Fingerprint"   "Setup Fingerprint Drivers(Limited HW)" \
    "x" "Back" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    GPU-Auto)
        bash "$SCRIPT_DIR/2.Drivers/Graphics/1.GPU-Auto-driver-selector.sh"
        echlog "Ran 1.GPU-Auto-driver-selector.sh."
    ;;
    Broadcom)
        bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/Broadcom-WL-BT.sh"
        echlog "Ran Broadcom-WL-BT.sh"
        # Eduroam
        if whiptail --title "$TITLE" --yesno "Install dependencie for Eduroam WiFi?\npython3-dbus" $HEIGHT $WIDTH; then
            sudo xbps-install -Syu python3-dbus
            echlog "Installed python3-dbus"
        fi
    ;;
    Realtek)
        DRIVER=$(whiptail --title "$TITLE" --menu "Install DKMS Wi-Fi Drivers" $HEIGHT $WIDTH $MENU_HEIGHT \
            "1" "Cancel" \
            "2" "Realtek rtl8822bu-dkms" \
            "3" "Realtek rtl8821cu-dkms" \
            "4" "Realtek rtl8821au-dkms" \
            "5" "Realtek rtl8812au-dkms" \
            3>&1 1>&2 2>&3)
        case $DRIVER in
            1) echlog "No DKMS wifi driver installed" ;;
            2) bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/rtl8822bu-dkms.sh" && echlog "Ran rtl8822bu-dkms.sh" ;;
            3) bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/rtl8821cu-dkms.sh" && echlog "Ran rtl8821cu-dkms.sh" ;;
            4) bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/rtl8821au-dkms.sh" && echlog "Ran rtl8821au-dkms.sh" ;;
            5) bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/rtl8812au-dkms.sh" && echlog "Ran rtl8812au-dkms.sh" ;;
        esac
        # Eduroam
        if whiptail --title "$TITLE" --yesno "Install dependencie for Eduroam WiFi?\npython3-dbus" $HEIGHT $WIDTH; then
            sudo xbps-install -Syu python3-dbus
            echlog "Installed python3-dbus"
        fi
    ;;
    Bluetooth)
        if whiptail --title "$TITLE" --yesno --defaultno \
        "Install and enalbe Bluetooth?\nbluez bluez-alsa libspa-bluetooths" $HEIGHT $WIDTH; then
            bash "$SCRIPT_DIR/2.Drivers/WiFi-and-Bluetooth/Bluetooth-service.sh"
        fi
    ;;
    Fingerprint)
        DRIVER_FINGERPRINT=$(whiptail --title "$TITLE" --menu \
        "Install DKMS Wi-Fi Drivers\nYou may need to use BCM-WL-FIX.desktop from section 7" $HEIGHT $WIDTH $MENU_HEIGHT \
            "1" "Cancel" \
            "2" "2541:0236 Chipsailing CS9711 Fingprint" \
            3>&1 1>&2 2>&3)
        case $DRIVER_FINGERPRINT in
            1) echlog "No Fingerprint driver installed" ;;
            3) bash "$SCRIPT_DIR/2.Drivers/Fingerprint/2541:0236_Chipsailing_CS9711Fingprint.sh" && echlog "Ran 2541:0236_Chipsailing_CS9711Fingprint.sh" ;;
        esac
    ;;
    *) return 0 ;;
    esac
done
}

# Desktop menu 6
desktop()
{
# Services
## Enable services (runs only if not already enabled)
if [ ! -e /var/service/dbus ] || [ ! -e /var/service/NetworkManager ]; then
    if whiptail --title "$TITLE" --yesno "Enable: NetworkManager and dbus\nThis will reboot the system\nRun if you did not select them during install or are not sure, re-run the script afterwards skipping this part" 10 60; then
        sudo xbps-install -Syu NetworkManager dbus
        for svc in NetworkManager dbus; do
            sudo ln -sf /etc/sv/$svc /var/service/
        done
        echlog "Setup Network Manager and Dbus services"
        sudo reboot
    else
        echlog "Skipped enabling NetworkManager/dbus. Current active services:"
        ls /var/service
    fi
else
    echlog "NetworkManager and dbus are already enabled. Skipping service setup."
fi
# Desktop Enviroment
DE=$(whiptail --title "$TITLE" --menu "Install/change Desktop Environment" 20 60 10 \
    "0" "None (No Changes)" \
    "1" "XFCE + plugins" \
    "2" "KDE Plasma" \
    "3" "Gnome" \
    "4" "Cinnamon" \
    "5" "Mate" \
    "6" "LXQT" \
    "7" "LXDE" \
    "8" "Enlightenment" \
    "9" "Budgie" \
    3>&1 1>&2 2>&3)
case $DE in
    0) echlog "No change with the desktop enviroment" ;;
    1) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/xfce4-and-plugins.sh" && echlog "Ran xfce4-and-plugins.sh" ;;
    2) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/kde-plasma.sh" && echlog "Ran kde-plasma.sh" ;;
    3) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/gnome.sh" && echlog "Ran gnome.sh" ;;
    4) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/cinnamon.sh" && echlog "Ran cinnamon.sh" ;;
    5) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/mate.sh" && echlog "Ran mate.sh" ;;
    6) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/lxqt.sh" && echlog "Ran lxqt.sh" ;;
    7) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/lxde.sh" && echlog "Ran lxde.sh" ;;
    8) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/enlightenment.sh" && echlog "Ran enlightenment.sh" ;;
    9) bash "$SCRIPT_DIR/4.Audio-Video-GUI/Desktop-Enviroments/budgie.sh" && echlog "Ran budgie.sh" ;;
esac
# Display Manager
bash "$SCRIPT_DIR/4.Audio-Video-GUI/ChangeDM.sh"
}

#==================================== Main Menu ====================================
while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose an installation mode:" $HEIGHT $WIDTH $MENU_HEIGHT \
    "1" "HW Info - Get advice about what you need based on your HW" \
    "2" "Repositories - Add or Remove SW Repositories (Propriatary and 32 Bit)" \
    "3" "Linux Kernel - Choose Linux kernel Versions and Parameters" \
    "4" "Drivers - Install and Setup drivers for your GPU and WiFi cards + Bluetooth" \
    "5" "Audio - Install and Setup Audio" \
    "6" "Desktop - Install a Desktop Enviroment" \
    "7" "Power Management - Setup Power Management services" \
    "8" "Miscellaneous setup - Usergroups, HW clock for Dualboot, Config Files" \
    "9" "Apps - Install programs from reccomended lists (Takes a Long Time)" \
    "x" "back to the Main menu" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    1)
        bash "$SCRIPT_DIR/1.Basic-Setup/HW-detection.sh"
        echlog "Ran HW-detection.sh"
    ;;
    2)
        bash "$SCRIPT_DIR/1.Basic-Setup/repos.sh"
        echlog "Ran repos.sh"
    ;;
    3)
        bash "$SCRIPT_DIR/1.Basic-Setup/Voidlinux-Kernel-Manager.sh"
        echlog Voidlinux-Kernel-Manager.sh
    ;;
    4) drivers ;;
    5)
        AUDIO=$(whiptail --title "$TITLE" --menu "Install a Audio Server" $HEIGHT $WIDTH $MENU_HEIGHT \
            "1" "Cancel" \
            "2" "Alsa+Pipewire+SOF firmware (recommended)" \
            3>&1 1>&2 2>&3)
        case $AUDIO in
            1) echlog "No audio server changes" ;;
            2)
                bash "$SCRIPT_DIR/4.Audio-Video-GUI/Audio/pipewire-alsa.sh"
                bash "$SCRIPT_DIR/4.Audio-Video-GUI/Audio/pipewire-autostart.sh"
                echlog "Ran pipewire-alsa.sh and pipewire-autostart.sh"
            ;;
        esac
    ;;
    6) desktop ;;
    7)
        PM=$(whiptail --title "$TITLE" --menu "Choose power management" $HEIGHT $WIDTH $MENU_HEIGHT \
            "1" "Cancel" \
            "2" "Power Profiles (Simple)" \
            "3" "TLP and run TLPUI (Powerfull)" \
            3>&1 1>&2 2>&3)
        case $PM in
            1) echlog "No Power managment Feature configured" ;;
            2) bash "$SCRIPT_DIR/1.Basic-Setup/Power-Managment/Power-Porfiles-Daemon.sh" && echlog "Ran Power-Porfiles-Daemon.sh" ;;
            3) bash "$SCRIPT_DIR/1.Basic-Setup/Power-Managment/TLP.sh" && echlog "Ran TLP.sh" ;;
        esac
    ;;
    8)
        # Usergroups
        if whiptail --title "$TITLE" --yesno "Add user $USER to recommended groups: wheel,floppy,dialout,audio,video,cdrom,optical,kvm,users,xbuilder,network?" 10 60; then
            bash "$SCRIPT_DIR/1.Basic-Setup/UserGroups.sh"
            echlog "added user to: wheel,floppy,dialout,audio,video,cdrom,optical,kvm,users,xbuilder,network groups"
            pause "User groups updated."
        fi
        # HW clock
        if whiptail --title "$TITLE" --yesno --defaultno "Use the HW clock (For windows Dualboot)" 10 60; then
            bash "$SCRIPT_DIR/1.Basic-Setup/HW-clock-For-Windows-Dualboot.sh"
            echlog "Set the clock to use HW clock"
            pause "HW clock set"
        fi
        # Config Files
        if whiptail --title "$TITLE" --yesno --defaultno "Add better config files for:\n-Mangohud\n-Fastfetch" 10 60; then
            bash "$SCRIPT_DIR/0.Info-Tools/5.Config-Files/install-config-files.sh"
            echlog "Added Mangohud and Fastfetch Config files to system"
            pause "Config Files Added."
        fi
    ;;
    9)
        if whiptail --title "$TITLE" --yesno --defaultno "Do You wish to run a App selection Script?\n You can choose between recommended and manually selected apps and programs" 10 60; then
            bash "$SCRIPT_DIR/5.Apps/00.Run-All.sh"
            pause "Apps based on your selection are installed"
            echlog "Ran 00.Run-All.sh"
        fi
    ;;
    *) exit 0 ;;
    esac
done
exit 0
