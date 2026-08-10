#!/bin/bash

#============================ Term Size ============================
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
HEIGHT=$TERM_HEIGHT
WIDTH=$TERM_WIDTH
MENU_HEIGHT=$((HEIGHT - 10))

#============================ Dependency Check ============================

if ! command -v topgrade >/dev/null 2>&1; then
    if whiptail --title "CPU Governor Selector" --yesno "It seems that you do not have Cpupower installed on your system.\nDo you wish to install it?" $HEIGHT $WIDTH; then
        echlog "Installing topgrade"
        sudo xbps-install -Syu cpupower
    else
        exit 0
    fi
fi

#============================ Get Current Governor ============================

CURRENT_GOV=$(cpupower frequency-info | grep "The governor" | awk -F\" '{print $2}')

[ -z "$CURRENT_GOV" ] && CURRENT_GOV="Unknown"

#============================ Governor Selection ============================

CHOICE=$(whiptail --title "CPU Governor Selector" \
--menu "Current governor: $CURRENT_GOV\n\nSelect new governor:" \
"$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
"performance" "Max performance, higher power usage" \
"powersave" "Lower power usage, lower performance" \
"schedutil" "Balanced, kernel-managed (recommended)" \
"ondemand" "Dynamic scaling (older but still useful)" \
"conservative" "Slow scaling, power efficient" \
3>&1 1>&2 2>&3)

# Handle cancel
[ $? -ne 0 ] && exit 0

#============================ Apply Governor ============================

if sudo cpupower frequency-set -g "$CHOICE" >/dev/null 2>&1; then
    whiptail --msgbox "CPU governor set to: $CHOICE" "$HEIGHT" "$WIDTH"
else
    whiptail --msgbox "Failed to set CPU governor.\nCheck permissions or kernel support." "$HEIGHT" "$WIDTH"
    exit 1
fi

exit 0
