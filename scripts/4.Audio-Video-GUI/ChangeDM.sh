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

#Main Function
change_dm() {
# Disable all current DMs
for dm in "${dms[@]}"; do
    if [ -L "/var/service/$dm" ]; then
        echo "Disabling $dm..."
        cd /var/service
        sudo rm -f "$dm"
    fi
done

# Enable new DM
if [ ! -L "/var/service/$CHOICEDM" ]; then
    echo "Enabling $CHOICEDM..."
    sudo ln -s "/etc/sv/$CHOICEDM" /var/service/
fi
    sudo reboot
exit 0
}

# Menu
DRIVER=$(whiptail --title "$TITLE" --menu "LAST QUESTION: Change or Add a Display Manager:\nCurrent DM: $CURRENTDM\n!!!Changing this will result in a reboot!!!" 20 70 7 \
    "1" "None" \
    "2" "SDDM (For KDE Plasma, LXQt)" \
    "3" "LightDM (For XFCE, Cinnamon, MATE, Enlightenment, Budgie)" \
    "4" "GDM (For GNOME)" \
    "5" "LXDM (For LXDE)" \
    "6" "Slim (Is Simple and Doesnt work with modern Desktops)" \
    "7" "XDM (Is Old and i have no idea how it works)" \
    3>&1 1>&2 2>&3)

# Default choice
CHOICEDM="NONE"

case $DRIVER in
    1) exit 0 ;;
    2)
    sudo xbps-install -Syu sddm sddm-kcm
    CHOICEDM="sddm"
    change_dm
    ;;
    3)
    sudo xbps-install -Syu lightdm lightdm-gtk-greeter
    CHOICEDM="lightdm"
    change_dm
    ;;
    4)
    sudo xbps-install -Syu gdm gdm-settings
    CHOICEDM="gdm"
    change_dm
    ;;
    5)
    sudo xbps-install -Syu lxdm lxdm-theme-vdojo
    CHOICEDM="lxdm"
    change_dm
    ;;
    6)
    sudo xbps-install -Syu slim slim-void-theme
    CHOICEDM="slim"
    change_dm
    ;;
    7)
    sudo xbps-install -Syu xdm
    CHOICEDM="xdm"
    change_dm
    ;;
    *) exit 0;;
esac



