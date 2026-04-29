#!/bin/bash
#============================
# Topgrade TUI
#============================

# 1 - Initial Parameters
HEIGHT=$(tput lines 2>/dev/null || echo 24)
WIDTH=$(tput cols 2>/dev/null || echo 80)
MENU_HEIGHT=$((HEIGHT - 10))
TITLE="Topgrade TUI"

# Config File path
VOID_TUI_CONF="$HOME/.local/state/VOID-TUI/VOID-TUI.conf"

if [ -f "$VOID_TUI_CONF" ]; then
    source "$VOID_TUI_CONF"
else
    # Providing a default so the script doesn't just crash if config is missing
    loggs="true"
    echo "Warning: Config file not found, using defaults."
fi

LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"
mkdir -p "$(dirname "$LOGFILE")" # Ensure log directory exists

#============================
# 2 - Helper Functions
#============================
echlog() {
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}
manual_selection_menu() {
    whiptail --title "$TITLE" --checklist "Choose what to upgrade:" $HEIGHT $WIDTH $MENU_HEIGHT \
        "${MANUAL_OPTIONS[@]}" \
        3>&1 1>&2 2>&3
}

#============================
# 3 - topgrade check
#============================
if ! command -v topgrade >/dev/null 2>&1; then
    if whiptail --title "$TITLE - Install" --yesno "It seems that you do not have Topgrade installed on your system.\nDo you wish to install it?" $HEIGHT $WIDTH; then
        echlog "Installing topgrade"
        sudo xbps-install -Syu xbps
        sudo xbps-install -Su topgrade
    else
        exit 0
    fi
fi

#============================
# 4 - Show Dry Run
#============================
# Create a temporary file to store the dry run output
DRY_RUN_OUT=$(mktemp)
echlog "Running echlog dry run..."
topgrade --dry-run > "$DRY_RUN_OUT" 2>&1

# Create a second temporary file for the folded text (for whiptail display)
FOLDED_OUT=$(mktemp)
fold -s -w $((WIDTH-4)) "$DRY_RUN_OUT" > "$FOLDED_OUT"

# Step A: Show the user what will happen in a textbox first
whiptail --title "Dry Run: Pending Updates" --textbox "$FOLDED_OUT" $HEIGHT $WIDTH

# Step B: Ask the user how to proceed
CHOICE=$(whiptail --title "Action Required" --menu \
        "Would you like to continue with the updates?" \
        $HEIGHT $WIDTH 4 \
        "yes"         "Yes, start (Interactive CLI)" \
        "yes_skip"    "Yes, install ALL (Auto-confirm)" \
        "choose"      "Select specific components" \
        "no"          "Exit/Cancel" \
        3>&1 1>&2 2>&3)

# Cleanup temp files immediately after use
rm -f "$DRY_RUN_OUT" "$FOLDED_OUT"

#============================
# 5 - Main Menu Logic
#============================
case $CHOICE in
    yes)
        echlog "Ran Updates using topgrade (Interactive)"
        topgrade
        ;;
    yes_skip)
        echlog "Ran Updates using topgrade (Auto-confirm)"
        topgrade -y
        ;;
    choose)
        # Get selection from checklist
        MANUAL_OPTIONS=(
            "system"        "System Packages" OFF
            "flatpak"       "Flatpak Apps" OFF
            "gearlever"     ".Appimages (Gearlever)" OFF
            "firmware"      "Device Firmware" OFF
            "clam_av_db"    "Clam AV Database" OFF
        )
        RAW=$(manual_selection_menu)
        if [ -z "$RAW" ]; then
            echo "No selections made. Exiting."
            exit 0
        fi
        ## The RAW output has " that package managers dont like
        ## The following commands remove quotes and convert into clean array
        RAW=${RAW//\"/}
        ## for reference: ${RAW//pattern/replacement}
        ## explanation:
            ### // replace for all occurrences
            ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "
        read -r -a SELECTED_PACKAGES <<< "$RAW"
        ## Install Packages
        echlog "Updating: ${SELECTED_PACKAGES[*]}"
        topgrade --only "${SELECTED_PACKAGES[@]}"

        ;;
    *)
        echlog "User cancelled updates."
        exit 0
        ;;
esac

exit 0
