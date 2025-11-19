#!/bin/bash
# Simple Whiptail-based Kernel Parameter TUI for GRUB

GRUB_FILE="/etc/default/grub"
BACKUP_FILE="/etc/default/grub.backup"

# Directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"

# One parameter per line, sitting next to this script
PARAM_LIST_FILE="$SCRIPT_DIR/kernel_params.conf"

# Check parameter list file
if [[ ! -f "$PARAM_LIST_FILE" ]]; then
    echo "Error: $PARAM_LIST_FILE not found."
    echo "Create it with one kernel parameter per line."
    exit 1
fi

# Read parameters into array, skipping empty lines and comments
mapfile -t AVAILABLE_PARAMS < <(grep -v '^\s*#' "$PARAM_LIST_FILE" | grep -v '^\s*$')

# Function: get current GRUB_CMDLINE_LINUX_DEFAULT
get_current_params() {
    grep '^GRUB_CMDLINE_LINUX_DEFAULT=' "$GRUB_FILE" \
        | sed 's/^GRUB_CMDLINE_LINUX_DEFAULT="//;s/"$//'
}

# Get current params and split into array
CURRENT_PARAMS_STR=$(get_current_params)
read -r -a CURRENT_PARAMS <<< "$CURRENT_PARAMS_STR"

# Build whiptail menu items (ON if currently set, OFF otherwise)
MENU_ITEMS=()
for param in "${AVAILABLE_PARAMS[@]}"; do
    if printf '%s\n' "${CURRENT_PARAMS[@]}" | grep -Fxq "$param"; then
        MENU_ITEMS+=("$param" "" "ON")
    else
        MENU_ITEMS+=("$param" "" "OFF")
    fi
done

# Show checklist
CHOICES=$(whiptail --title "Kernel Parameter Manager" \
    --checklist "Select kernel parameters to enable:" 20 78 12 \
    "${MENU_ITEMS[@]}" \
    3>&1 1>&2 2>&3)

# Exit if cancelled
[ $? -ne 0 ] && echo "Cancelled." && exit 0

# Convert selection to array
read -r -a SELECTED_PARAMS <<< "$(echo "$CHOICES" | tr -d '"')"

# Preserve unmanaged params
NEW_PARAMS=()
for p in "${CURRENT_PARAMS[@]}"; do
    if printf '%s\n' "${AVAILABLE_PARAMS[@]}" | grep -Fxq "$p"; then
        # managed param — only keep if selected
        if printf '%s\n' "${SELECTED_PARAMS[@]}" | grep -Fxq "$p"; then
            NEW_PARAMS+=("$p")
        fi
    else
        # unmanaged param — always keep
        NEW_PARAMS+=("$p")
    fi
done

# Add newly selected params that weren't in the original list
for p in "${SELECTED_PARAMS[@]}"; do
    if ! printf '%s\n' "${NEW_PARAMS[@]}" | grep -Fxq "$p"; then
        NEW_PARAMS+=("$p")
    fi
done

# Final string
FINAL_PARAMS=$(printf "%s " "${NEW_PARAMS[@]}" | sed 's/ $//')

# Backup grub config
echo "Backing up $GRUB_FILE to $BACKUP_FILE..."
sudo cp "$GRUB_FILE" "$BACKUP_FILE"

# Write updated params
echo "Updating kernel parameters in $GRUB_FILE..."
sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$FINAL_PARAMS\"|" "$GRUB_FILE"

# Ask to update grub
if whiptail --yesno "Parameters updated:\n$FINAL_PARAMS\n\nRun update-grub now?" 15 70; then
    sudo update-grub
    whiptail --msgbox "GRUB updated. Please reboot for changes to take effect." 8 50
else
    whiptail --msgbox "Changes saved. Remember to run update-grub before rebooting." 8 60
fi
