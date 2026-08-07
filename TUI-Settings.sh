#!/bin/bash
set -euo pipefail
#============================ 0.1 VOID-TUI Config File ============================
VOID_TUI_CONF="$HOME/.local/state/VOID-TUI/VOID-TUI.conf"
if [ -f "$VOID_TUI_CONF" ]; then
    source "$VOID_TUI_CONF"
else
    echo "No VOID-TUI config file, please run VOID-TUI.sh first!"
    exit 1
fi
#New parameter sourced from config file:
## loggs (true or false)

#============================ Logging ============================
# Log what happens in TUI
LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"

echlog()
{
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}

#============================ Script location ============================
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

#============================ Term Size ============================
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
HEIGHT="$TERM_HEIGHT"
WIDTH="$TERM_WIDTH"
MENU_HEIGHT=$((HEIGHT - 10))
### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu
TITLE="Void-Post-Install-Script GIT"

#============================ Functinos ============================
choose_editor()
{
    whiptail --title "Choose editor" --menu "Select editor:" $HEIGHT $WIDTH $MENU_HEIGHT \
        less        "Simple, read only (q to quit)" \
        nano        "Simple terminal editor (CTR+X to quit)" \
        vim         "Advanced terminal editor (No one knows how to quit)" \
        kate        "KDEs graphical notepad" \
        mousepad    "XFCEs graphical notepad" \
        3>&1 1>&2 2>&3
}

set_colors()
{
#===================================================
# TUI Theme Switcher for Voidlinux Post Install TUI
#===================================================

NEWT_COLORS_FILE="$HOME/.local/state/VOID-TUI/colors.conf"

while true; do
    CHOICE=$(whiptail --title "Theme Selector" --menu "Choose a color preset:" $HEIGHT $WIDTH $MENU_HEIGHT \
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
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "Matrix theme applied!" $HEIGHT $WIDTH
            ;;
        2) # Commodore 64
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "Commodore 64 theme applied!" $HEIGHT $WIDTH
            ;;
        3) # PC CGA
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "PC CGA theme applied!" $HEIGHT $WIDTH
            ;;
        4) # Ubuntu Orange
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "Ubuntu Orange theme applied!" $HEIGHT $WIDTH
            ;;
        5) # Linux Mint Green
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "Linux Mint Green theme applied!" $HEIGHT $WIDTH
            ;;
        6) # KDE Breeze
            cat > "$NEWT_COLORS_FILE" <<EOF
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
            whiptail --msgbox "KDE Breeze theme applied!" $HEIGHT $WIDTH
            ;;
        7) # Default
            echo "# Default (empty)" > "$NEWT_COLORS_FILE"
            whiptail --msgbox "Default theme applied (no colors)." $HEIGHT $WIDTH
            ;;
        8) # Exit
            exit 0
            ;;
        *)
            exit 1
            ;;
    esac
done

}
#============================ Main Menu ============================
while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Select an action:" "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
        logs            "📜 View Logs from the TUI's" \
        config          "📂 Set Logging (Curently: $loggs)" \
        colors          "🎨 Change the Colors of the TUI" \
        desktop_file    "🖥️ Add a VOID-TUI.desktop to your desktop" \
        go_back         ".. Go Back" \
        3>&1 1>&2 2>&3) || CHOICE="exit" ##exit for cancel button
    case "$CHOICE" in
    logs)
        # See if the log file exists
        if [ ! -f "$LOGFILE" ]; then
            whiptail --title "Logfile not found" --msgbox "No logfile found at:$LOGFILE" $HEIGHT $WIDTH
            echlog "📜 Log File: $LOGFILE Not Found!"
        else

        ##Choose editor
        EDITOR=$(choose_editor) || continue
        echlog "📜 Opening $LOGFILE using $EDITOR"
        "$EDITOR" "$LOGFILE"
        fi
    ;;
    config)
        if whiptail --title "$TITLE - Logging📂" --yesno "Do you wish to have loggs enabled?" $HEIGHT $WIDTH; then
            loggs="true"
        else
            loggs="false"
        fi

cat > "$VOID_TUI_CONF" <<EOF
loggs="$loggs"
EOF
    ;;
    colors)
        set_colors
    ;;
    desktop_file)
        if ! xbps-query -c -s xdg-user-dirs >/dev/null 2>&1; then
            echlog "Install xdg-user-dirs:"
            sudo xbps-install -Syu xdg-user-dirs
        fi
        DESKTOP_DIR=$(xdg-user-dir DESKTOP)
        mkdir -p $DESKTOP_DIR
        cp "$(dirname "$(realpath "$0")")/VOID-TUI.desktop" "$DESKTOP_DIR/"
        echlog "Coppied VOID-TUI.desktop to $DESKTOP_DIR"
        whiptail --title "$TITLE" --msgbox "Coppied VOID-TUI.desktop to $DESKTOP_DIR" $HEIGHT $WIDTH
    ;;
    *) exit 0 ;;
    esac
done
