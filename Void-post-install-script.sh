#!/bin/bash

#==================================== Define parameters ====================================

# SCRIPT_DIR should point to the base directory containing your numbered script folders.
# Assuming this script is in the same directory as the 'scripts' folder.
SCRIPT_DIR="$(dirname "$(realpath "$0")")/scripts"
TITLE="Void-Post-Install-Script" # This will be the main title
BACKTITLE="Select and Item" # appears in top-left
HEIGHT=35 # Adjusted height for better multi-level display
WIDTH=100  # Adjusted width
MENU_HEIGHT=16 # More items visible


#==================================== Functions ====================================

# --- Function to check base directory permissions ---
# This check remains in the main script as it's crucial for the script's core functionality.
check_base_dir_permissions() {
# Check initial SCRIPT_DIR permissions and existence
    if [ ! -d "$SCRIPT_DIR" ]; then
        echo "Error: The 'scripts' directory was not found at '$SCRIPT_DIR'." >&2
        echo "Please ensure the 'scripts' folder is present next to 'post_install_tui.sh'." >&2
        exit 1
    fi
    if [ ! -r "$SCRIPT_DIR" ] || [ ! -x "$SCRIPT_DIR" ]; then
        echo "Error: Insufficient permissions for directory '$SCRIPT_DIR'." >&2
        echo "Please ensure you have read (r) and execute (x) permissions on this directory." >&2
        echo "Try: chmod u+rx \"$SCRIPT_DIR\"" >&2
        exit 1
    fi
}


# --- Generic Function to run a script ---
run_script() {
    local script_path="$1"
    local script_name="$(basename "$script_path")"

    if [ ! -f "$script_path" ]; then
        whiptail --msgbox "Error: Script '$script_name' not found at '$script_path'." "$HEIGHT" "$WIDTH"
        return 1
    fi

# --- Executable permissions check ---
    if [ ! -x "$script_path" ]; then
        whiptail --msgbox "Script '$script_name' is not executable. Attempting to add permissions..." "$HEIGHT" "$WIDTH"
        sudo chmod +x "$script_path"
        if [ $? -ne 0 ]; then
            whiptail --msgbox "Error: Failed to make '$script_name' executable. Cannot run. Check permissions." "$HEIGHT" "$WIDTH"
            return 1
        fi
    fi

# --- Confirmation Logic ---
    if ! (whiptail --title "Confirm Run" --yesno "Are you sure you want to run '$script_name'?" 10 60); then
        echo "User cancelled running '$script_name'." >&2
        return 0 # User chose not to run, return to menu
    fi

# --- Script Execution ---
    "$script_path"
    read -p "Done, press enter to continue"
    return 0
}
display_dynamic_menu() {
    local title="$1"
    local current_path="$2"
    local original_path="$2" # Keep track of the original starting point

    while true; do
        # Build the menu options
        local menu_options=()

        # Add "Go back" option unless we're at the root of the script directory.
        # This provides a way to navigate up a level in the folder structure.
        if [[ "$current_path" != "$original_path" ]]; then
            menu_options+=("..-back" "Go back to the previous menu")
        fi

        # Find folders, scripts, and text files in the current directory.
        # We use 'find' with '-maxdepth 1' to only look in the current directory,
        # and then sort the results for a consistent menu order.
        local items
        items=$(find "$current_path" -maxdepth 1 -mindepth 1 \( -type d -o -type f -name "*.sh" -o -type f ! -name "*.sh" \) | sort)

        # Process each item found and add it to our menu options array.
        while read -r item; do
            local item_name
            item_name=$(basename "$item")

            if [ -d "$item" ]; then
                # If the item is a directory, add it to the menu with a label indicating it's a folder.
                menu_options+=("$item_name" "(Folder) Enter this folder")
            elif [ -f "$item" ] && [[ "$item_name" == *.sh ]]; then
                # If the item is a script with a '.sh' extension, add it to the menu with a script label.
                menu_options+=("$item_name" "(Script) Run this script")
            elif [ -f "$item" ]; then
                # If the item is a file but not a '.sh' script, we'll assume it's a text file to be read.
                menu_options+=("$item_name" "(File) Read this file")
            fi
        done <<< "$items"

        # Add an "Exit" option to the menu. This option will be available at all levels.
        menu_options+=("Exit" "Exit the script")

        # Check if the menu is empty, which can happen if a folder has no scripts or sub-folders.
        if [ ${#menu_options[@]} -eq 0 ]; then
            whiptail --msgbox "This directory is empty." "$HEIGHT" "$WIDTH"
            # If the current path isn't the original path, we can go back up.
            if [[ "$current_path" != "$original_path" ]]; then
                current_path=$(dirname "$current_path")
                continue # Skip to the next loop iteration.
            else
                break # If we're at the top and it's empty, we should exit the loop.
            fi
        fi

        # Use whiptail to display the menu to the user. The user's selection is stored in the 'choice' variable.
        local choice
        choice=$(whiptail --title "$TITLE" --backtitle "$BACKTITLE" \
                          --menu "$title" "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
                          "${menu_options[@]}" 3>&1 1>&2 2>&3)

        # Check the exit status of whiptail. If it's not 0 (e.g., the user pressed Escape), we break the loop.
        if [ $? -ne 0 ]; then
            break
        fi

        # Process the user's choice based on the selected option.
        if [[ "$choice" == "Exit" ]]; then
            # The user explicitly chose to exit the script.
        echo "=========================================="
        echo "  Thank you for using My Voidlinux-Post-Install-TUI!   "
        echo "=========================================="
        exit 0
        elif [[ "$choice" == "..-back" ]]; then
            # The user chose to go back. We update the current path to the parent directory.
            current_path=$(dirname "$current_path")
            title="Go Back" # Update title for the next menu display.
        else
            local chosen_path="$current_path/$choice"

            if [ -d "$chosen_path" ]; then
                # The user selected a folder, so we enter it by updating the current path.
                current_path="$chosen_path"
                title="Inside: $choice" # Update the title to reflect the new location.
            elif [ -f "$chosen_path" ] && [[ "$chosen_path" == *.sh ]]; then
                # The user selected a script, so we call the 'run_script' function.
                run_script "$chosen_path"
            elif [ -f "$chosen_path" ]; then
                # The user selected a file to read. We will now use 'less' to display it.
                # This provides a full-screen, scrollable view.
                clear
                less "$chosen_path"
                # The script will continue after 'less' is closed by the user (by pressing 'q').
            else
                # This is a fallback for when a selected file or folder is no longer available.
                whiptail --msgbox "Error: '$choice' could not be found or is not a valid script." "$HEIGHT" "$WIDTH"
            fi
        fi
    done
}


#==================================== Main Script Logic ====================================

clear # Clear the screen before the first menu appears.

# 1. Check initial directory permissions (dependency check now in install_deps.sh)
check_base_dir_permissions

# 2. Set all .sh scripts to executable
find scripts/ -type f -name "*.sh" -exec chmod +x {} \;

# 3. Start the dynamic menu navigation from the root 'scripts' directory
display_dynamic_menu "Main Menu" "$SCRIPT_DIR"


