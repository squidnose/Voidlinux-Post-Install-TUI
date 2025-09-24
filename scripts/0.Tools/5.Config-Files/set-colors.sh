#!/bin/bash
#===================================================
# TUI Theme Switcher for Voidlinux Post Install TUI
#===================================================

CONF_FILE="$(dirname "$(realpath "$0")")/colors.conf"

while true; do
    CHOICE=$(whiptail --title "Theme Selector" --menu "Choose a color preset:" 25 80 15 \
        1 "Matrix (Green on Black)" \
        2 "Commodore 64 (Blue/Light Blue)" \
        3 "PC CGA (Magenta & Cyan)" \
        4 "Ubuntu Orange" \
        5 "Linux Mint Green" \
        6 "KDE Breeze (Blue/Cyan)" \
        7 "Default (reset / no colors)" \
        8 "Exit" 3>&1 1>&2 2>&3)

    case $CHOICE in
        1) # Matrix
            cat > "$CONF_FILE" <<EOF
# Matrix
root=,black
window=,black
title=brightgreen,black
border=green,black
textbox=brightgreen,black
button=black,green
compactbutton=green,black
listbox=green,black
actlistbox=black,brightgreen
helpline=green,black
roottext=brightgreen,black
EOF
            whiptail --msgbox "Matrix theme applied!" 8 40
            ;;
        2) # Commodore 64
            cat > "$CONF_FILE" <<EOF
# Commodore 64
root=blue,blue
window=lightgray,blue
title=lightblue,blue
border=lightblue,blue
textbox=lightgray,blue
button=blue,lightgray
compactbutton=lightblue,blue
listbox=lightblue,blue
actlistbox=blue,lightblue
helpline=lightblue,blue
roottext=lightblue,blue
EOF
            whiptail --msgbox "Commodore 64 theme applied!" 8 40
            ;;
        3) # PC CGA
            cat > "$CONF_FILE" <<EOF
# PC CGA
root=,black
window=,black
title=magenta,black
border=cyan,black
textbox=cyan,black
button=black,magenta
compactbutton=magenta,black
listbox=cyan,black
actlistbox=black,cyan
helpline=magenta,black
roottext=cyan,black
EOF
            whiptail --msgbox "PC CGA theme applied!" 8 40
            ;;
        4) # Ubuntu Orange
            cat > "$CONF_FILE" <<EOF
# Ubuntu Orange
root=,black
window=,black
title=brightred,black
border=yellow,black
textbox=brightred,black
button=black,brightred
compactbutton=brightred,black
listbox=brightred,black
actlistbox=black,brightred
helpline=brightred,black
roottext=brightred,black
EOF
            whiptail --msgbox "Ubuntu Orange theme applied!" 8 40
            ;;
        5) # Linux Mint Green
            cat > "$CONF_FILE" <<EOF
# Linux Mint Green
root=,black
window=,black
title=brightgreen,black
border=green,black
textbox=green,black
button=black,brightgreen
compactbutton=green,black
listbox=brightgreen,black
actlistbox=black,green
helpline=brightgreen,black
roottext=green,black
EOF
            whiptail --msgbox "Linux Mint Green theme applied!" 8 40
            ;;
        6) # KDE Breeze
            cat > "$CONF_FILE" <<EOF
# KDE Breeze
root=,black
window=,black
title=brightcyan,black
border=blue,black
textbox=cyan,black
button=black,brightcyan
compactbutton=cyan,black
listbox=brightcyan,black
actlistbox=black,cyan
helpline=cyan,black
roottext=cyan,black
EOF
            whiptail --msgbox "KDE Breeze theme applied!" 8 40
            ;;
        7) # Default
            echo "# Default (empty)" > "$CONF_FILE"
            whiptail --msgbox "Default theme applied (no colors)." 8 40
            ;;
        8) # Exit
            exit 0
            ;;
        *)
            exit 1
            ;;
    esac
done
