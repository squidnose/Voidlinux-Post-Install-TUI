#!/bin/bash
TITLE="App Selector"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Tell the user how to use the controls
whiptail --title "$TITLE" --msgbox "Welcome to the App Selector!\n\nControls:\n- SPACE = Select/Deselect an item\n- TAB = Switch buttons\n- ENTER = Confirm selection\n\nPress OK to continue." 25 60

# Array to store selected scripts
declare -a SELECTED_SCRIPTS=()

# Function to browse a category
browse_category() {
    local category="$1"
    local files=("$SCRIPT_DIR/$category"/*.sh)
    local checklist_items=()

    # Build whiptail checklist entries
    for f in "${files[@]}"; do
        local fname="$(basename "$f")"
        checklist_items+=("$fname" "" OFF)
    done

    # If no scripts found
    if [ ${#checklist_items[@]} -eq 0 ]; then
        whiptail --title "$TITLE" --msgbox "No scripts found in $category." 10 40
        return
    fi

    # Show checklist
    local selected
    selected=$(whiptail --title "Category: $category" \
        --checklist "Select apps to install from $category" 25 78 15 \
        "${checklist_items[@]}" \
        3>&1 1>&2 2>&3)

    # Add selected scripts to global array
    for choice in $selected; do
        choice="${choice//\"/}" # Remove quotes
        SELECTED_SCRIPTS+=("$SCRIPT_DIR/$category/$choice")
    done
}

# Main menu loop
while true; do
    # Build category list from folders
    mapfile -t categories < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

    # Add "Done" option
    menu_items=()
    for cat in "${categories[@]}"; do
        menu_items+=("$cat" "")
    done
    menu_items+=("DONE" "Run selected scripts")

    # Show menu
    choice=$(whiptail --title "$TITLE" --menu "Select a category to browse, or DONE to run scripts." 25 78 17 \
        "${menu_items[@]}" \
        3>&1 1>&2 2>&3)

    # Handle choice
    if [ "$choice" = "DONE" ]; then
        break
    elif [ -n "$choice" ]; then
        browse_category "$choice"
    else
        # Cancel pressed
        exit 1
    fi
done

# Final confirmation
if [ ${#SELECTED_SCRIPTS[@]} -eq 0 ]; then
    whiptail --title "$TITLE" --msgbox "No scripts selected. Exiting." 10 40
    exit 0
fi

whiptail --title "$TITLE" --yesno "You selected ${#SELECTED_SCRIPTS[@]} scripts.\nRun them now?" 10 60
if [ $? -ne 0 ]; then
    exit 0
fi

# Run selected scripts
for script in "${SELECTED_SCRIPTS[@]}"; do
    chmod +x "$script"
    bash "$script"
done

whiptail --title "$TITLE" --msgbox "All selected scripts have been executed." 10 40
