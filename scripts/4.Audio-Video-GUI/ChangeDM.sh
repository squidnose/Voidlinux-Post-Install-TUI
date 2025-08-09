#!/bin/bash
dms=("lightdm" "gdm" "lxdm" "slim" "xdm" "sddm") # List of available DMs

# Find current DM
CURRENTDM="None detected"
for dm in "${dms[@]}"; do
    if [ -L "/var/service/$dm" ]; then
        CURRENTDM=$dm
        break
    fi
done

# Menu
DRIVER=$(whiptail --title "$TITLE" --menu "LAST QUESTION: Change or Add a Display Manager:\nCurrent DM: $CURRENTDM\n!!!Changing this will result in a reboot!!!" 20 70 7 \
    "1" "None" \
    "2" "SDDM (For KDE Plasma, LXQt)" \
    "3" "LightDM (For XFCE, Cinnamon, MATE, Enlightenment, Budgie)" \
    "4" "GDM (For GNOME)" \
    "5" "LXDM (For LXDE)" \
    "6" "Slim (Is Simple)" \
    "7" "XDM (Is Old and Basic)" \
    3>&1 1>&2 2>&3)

# Default choice
CHOICEDM="NONE"

case $DRIVER in
    1) CHOICEDM="NONE" ;;
    2) sudo xbps-install -Syu sddm sddm-kcm && CHOICEDM="sddm" ;;
    3) sudo xbps-install -Syu lightdm lightdm-gtk-greeter && CHOICEDM="lightdm" ;;
    4) sudo xbps-install -Syu gdm gdm-settings && CHOICEDM="gdm" ;;
    5) sudo xbps-install -Syu lxdm lxdm-theme-vdojo && CHOICEDM="lxdm" ;;
    6) sudo xbps-install -Syu slim slim-void-theme && CHOICEDM="slim" ;;
    7) sudo xbps-install -Syu xdm && CHOICEDM="xdm" ;;
esac

# If no change
if [ "$CHOICEDM" = "NONE" ]; then
    exit 0
fi

# Disable all current DMs
for dm in "${dms[@]}"; do
    if [ -L "/var/service/$dm" ]; then
        echo "Disabling $dm..."
        sudo rm -f "/var/service/$dm"
    fi
done

# Enable new DM
if [ ! -L "/var/service/$CHOICEDM" ]; then
    echo "Enabling $CHOICEDM..."
    sudo ln -s "/etc/sv/$CHOICEDM" /var/service/
fi
    sudo reboot
exit 0
