#!/bin/bash
# Post-Install-Setup-Wizard.sh
clear
echo "=========================================="
echo "  Debug Output, plese chek for any erors: "
echo "=========================================="
#Direcotry setup
set -e

BASE_DIR="$(dirname "$(realpath "$0")")/scripts"

# Basic variables
TITLE="Void Linux Post-Install Wizard"
BACKTITLE="Void Linux Streamlined Setup"

pause() {
    whiptail --title "$TITLE" --msgbox "$1" 15 60
}
# 0.1 Welcome
pause "Hello $USER. Do you wish to continue in this wizard?\nClose to cancel, anything to continue."

# 0.2 HW info detection
if whiptail --title "$TITLE" --yesno "Do you wish to find out Basic system specs and recomendations?" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/HW-detection.sh"
    echo "Ran HW-detection.sh"
fi


# 1. Check & update groups
if whiptail --title "$TITLE" --yesno "Add user $USER to recommended groups: wheel,floppy,dialout,audio,video,cdrom,optical,kvm,users,xbuilder,network?" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/UserGroups.sh"
    echo "added user to: wheel,floppy,dialout,audio,video,cdrom,optical,kvm,users,xbuilder,network groups"
    pause "User groups updated."
fi

# 2. Update system
if whiptail --title "$TITLE" --yesno "Update and sync System XBPS now?" 10 60; then
    sudo xbps-install -Syu xbps
    sudo xbps-install -Syu
    echo "Updated system XBPS"
    pause "System updated."
else
    echo "Did not run system Update, this may cause issues!!!"
fi

# 3. Enable services
if whiptail --title "$TITLE" --yesno "Enable: NetworkManager, dbus, and elogind?\nThis will reboot the system\nRun if you did not select them duiring install or are not sure, re-run the script afterwoods skipping this part" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/services-networkmanager-dbus-elogind.sh"
    echo "Ran services-networkmanager-dbus-elogind.sh"
    sudo reboot
else
    echo "Did not enable or disable NetworkManager, dbus or elogind. Check if they are turned on/listed here:"
    ls /var/service
fi
# 4.0 Install recommended utilities
if whiptail --title "$TITLE" --yesno "Install recommended utilities:\n git, wget, curl, nano?" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/utils-recommended.sh"
    echo "Installed recommended utilities"
    pause "recommended utilities installed."
fi

# 4.1 Install optional utilities
if whiptail --title "$TITLE" --yesno "Install Informational utilities:\n ncdu, fastfetch, htop, tmux, btop, cmatrix, nvme-cli?" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/utils-informational.sh"
    echo "Installed informational utilities"
    pause "Informational utilities installed."
fi

# 4.2 Install Fun utilities
if whiptail --title "$TITLE" --yesno "Install Fun utilities: cmatrix, oneko, cowsay, espeak, fortune-mod-void?" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/utils-fun.sh"
    echo "Installed Fun utilities"
    pause "Fun utilities installed."
fi

# 5. Add repositories
if whiptail --title "$TITLE" --yesno "Enable More Repositories?\nnonfree, multilib-nonfree and flathub\nImportant for Steam, Discord, Nvidia or Broadcom Users!" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/repos.sh"
    echo "Installed nonfree, multilib-nonfree and flathub repositories"
    pause "Repos installed."
else
    echo "Did not enable repositories, this will greatly decreese functionality."
fi

# 6. Install kernel headers (DKMS)
if whiptail --title "$TITLE" --yesno "Install Linux headers for DKMS modules? \nImportant for Nvidia or Broadcom Users!" 10 60; then
    bash "$BASE_DIR/1.Basic-Setup/dkms.sh"
    echo "Enabled DKMS for normal/Stable kernel"
    pause "Headers installed."
fi

# 7. Kernel choice
KERNEL=$(whiptail --title "$TITLE" --menu "Choose a kernel" 15 60 4 \
    "1" "Normal/Stable (Installed by Default)" \
    "2" "Latest/Mainline +DKMS (For Newer HW)" \
    "3" "LTS/Old +DKMS (For older Nvidia drivers 390 and 470)" \
    "4" "Custom version" \
    3>&1 1>&2 2>&3)
case $KERNEL in
    1) echo "Kept the Normal/Stable kernel" ;;
    2) bash "$BASE_DIR/1.Basic-Setup/new-kernel+dkms.sh" && echo "Installed the New mainline kernel +dkms" ;;
    3) bash "$BASE_DIR/1.Basic-Setup/old-kernel+dkms.sh" && echo "Installed the older LTS kernel +dkms. You may need to manually select it during boot." ;;
    4) pause "TBD" ;;
esac

# 7.5 kernel Optimization
KERNELOPTI=$(whiptail --title "$TITLE" --menu "Install Kernel Optimizations?" 15 60 6 \
    "1" "None" \
    "2" "AMD optimizations" \
    "3" "Intel Disable Specter and Meltdown (Lose security)" \
    3>&1 1>&2 2>&3)
case $KERNELOPTI in
    1) echo "No Kernel Optimizations Applied" ;;
    2) bash "$BASE_DIR/0.Tools/4.Kernel-Parameter-Optimizations/1.Presets/AMD-Ryzen-optimizations.sh" && echo "ran AMD-Ryzen-optimizations.sh" ;;
    3) bash "$BASE_DIR/0.Tools/4.Kernel-Parameter-Optimizations/1.Presets/Intel-Specter-Meltdown.sh" && echo "ran Intel-Specter-Meltdown.sh" ;;
esac

# 8. GPU driver choice
if whiptail --title "$TITLE" --yesno "Install GPU drivers and GPU related packages?" 10 60; then
    bash "$BASE_DIR/2.GPU-drivers/GPU-Auto-driver-selector.sh"
    echo "Driver Installer Ran."
fi

# 9. Wi-Fi drivers
DRIVER=$(whiptail --title "$TITLE" --menu "Install DKMS Wi-Fi Drivers\nYou may need to use BCM-WL-FIX.desktop in section 7" 15 60 6 \
    "1" "None" \
    "2" "Broadcom WiFi and Bluetooth-firmware" \
    "3" "Realtek rtl8822bu-dkms" \
    "4" "Realtek rtl8821cu-dkms" \
    "5" "Realtek rtl8821au-dkms" \
    "6" "Realtek rtl8812au-dkms" \
    3>&1 1>&2 2>&3)
case $DRIVER in
    1) echo "No DKMS wifi driver installed" ;;
    2) bash "$BASE_DIR/7.Drivers-Wifi-and-Others/Broadcom-WL-BT.sh" && echo "Ran Broadcom-WL-BT.sh" ;;
    3) bash "$BASE_DIR/7.Drivers-Wifi-and-Others/rtl8822bu-dkms.sh" && echo "Ran rtl8822bu-dkms.sh" ;;
    4) bash "$BASE_DIR/7.Drivers-Wifi-and-Others/rtl8821cu-dkms.sh" && echo "Ran rtl8821cu-dkms.sh" ;;
    5) bash "$BASE_DIR/7.Drivers-Wifi-and-Others/rtl8821au-dkms.sh" && echo "Ran rtl8821au-dkms.sh" ;;
    6) bash "$BASE_DIR/7.Drivers-Wifi-and-Others/rtl8812au-dkms.sh" && echo "Ran rtl8812au-dkms.sh" ;;
esac

#9.1 eduroam
if whiptail --title "$TITLE" --yesno "Install dependencie for Eduroam WiFi?\npython3-dbus" 10 60; then
    sudo xbps-install -Syu python3-dbus
    pause "python3-dbus is now installed."
    echo "Installed python3-dbus"
fi

#9.2 Bluetooth service
if whiptail --title "$TITLE" --yesno "Install and enalbe Bluetooth?\nbluez bluez-alsa libspa-bluetooths" 10 60; then
    bash "$BASE_DIR/7.Drivers-Wifi-and-Others/Bluetooth-service.sh"
fi

# 10. Power management
PM=$(whiptail --title "$TITLE" --menu "Choose power management" 15 60 3 \
    "1" "Power Profiles" \
    "2" "TLP and run TLPUI" \
    "3" "None" \
    3>&1 1>&2 2>&3)
case $PM in
    1) bash "$BASE_DIR/6.Power-Managment/Power-Porfiles-Daemon.sh" && echo "Ran Power-Porfiles-Daemon.sh" ;;
    2) bash "$BASE_DIR/6.Power-Managment/TLP.sh" && echo "Ran TLP.sh" ;;
    3) echo "No Power managment Feature configured" ;;
esac

# 11. Desktop environment choice
DE=$(whiptail --title "$TITLE" --menu "Install/change Desktop Environment" 20 60 10 \
    "0" "None" \
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
    0) echo "No change with the desktop enviroment" ;;
    1) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/xfce4-and-plugins.sh" && echo "Ran xfce4-and-plugins.sh" ;;
    2) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/kde-plasma.sh" && echo "Ran kde-plasma.sh" ;;
    3) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/gnome.sh" && echo "Ran gnome.sh" ;;
    4) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/cinnamon.sh" && echo "Ran cinnamon.sh" ;;
    5) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/mate.sh" && echo "Ran mate.sh" ;;
    6) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/lxqt.sh" && echo "Ran lxqt.sh" ;;
    7) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/lxde.sh" && echo "Ran lxde.sh" ;;
    8) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/enlightenment.sh" && echo "Ran enlightenment.sh" ;;
    9) bash "$BASE_DIR/4.Audio-Video-GUI/Desktop-Enviroments/budgie.sh" && echo "Ran budgie.sh" ;;
esac

#11.1 Audio Setup
AUDIO=$(whiptail --title "$TITLE" --menu "Install a Audio Server" 15 60 4 \
    "1" "Alsa+Pipewire+SOF firmware (recommended)" \
    "2" "ALSA not ready" \
    "3" "Pulse Audio not ready" \
    "4" "None" \
    3>&1 1>&2 2>&3)
case $AUDIO in
    1) bash "$BASE_DIR/4.Audio-Video-GUI/Audio/pipewire-alsa.sh" && bash "$BASE_DIR/4.Audio-Video-GUI/Audio/pipewire-autostart.sh" && echo "Ran pipewire-alsa.sh and pipewire-autostart.sh" ;;
    2) pause "TBD" ;;
    3) pause "TBD" ;;
    4) echo "No audio server changes" ;;

esac

# 11.2 OctoXBPS and Discover
if whiptail --title "$TITLE" --yesno "Do you want to install GUI front ends for XBPS and flathub?\nInstall octoxbps and discover?" 10 60; then
    sudo xbps-install -Syu octoxbps discover
    pause "octoxbps and discover are now installed."
    echo "octoxbps and discover are now installed."
fi

#11.3
if whiptail --title "$TITLE" --yesno "Do You want to install a Web Browser of your choosing?" 10 60; then
    bash "$BASE_DIR/5.Apps/01.Internet/Browser-Selection.sh"
    pause "A web browser of your choosing is now installed."
    echo "A web browser of your choosing is now installed."
fi

if whiptail --title "$TITLE" --yesno "Do You wish to run a App selection Script?\n You can choose between recommended and manually selected apps" 10 60; then
    bash "$BASE_DIR/5.Apps/GUI-apps-AIO.sh"
    pause "Apps based on your selection are installed"
    echo "A web browser of your choosing is now installed."
fi

# 12. Desktop shortcut
if whiptail --title "$TITLE" --yesno "Do you wish to add a desktop shortcut for a Non streamlined verison of this script?" 10 60; then
    cp $(dirname "$(realpath "$0")")/Run-New-Void-TUI-XFCE.sh ~/Desktop
    cp $(dirname "$(realpath "$0")")/Run-New-Void-TUI.desktop ~/Desktop
fi

# 13. Display manager
bash "$BASE_DIR/4.Audio-Video-GUI/ChangeDM.sh"

#14. The end
if whiptail --title "$TITLE" --yesno "Reboot to apply some changes?" 10 60; then
    sudo reboot
fi

echo "=========================================="
echo "Thank you for using My Voidlinux wizzard! "
echo "=========================================="
