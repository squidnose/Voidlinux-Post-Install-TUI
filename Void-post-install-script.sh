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
    return 0
}

# --- Generic function to display a menu for a given path ---
# This is the core function that enables the interactive, multi-level menu navigation.
# It dynamically discovers and lists sub-folders and executable scripts within a specified directory.
# Arguments:
# $1: The title to display at the top of the current menu.
#     (e.g., "Main Menu", "GPU Drivers", extracted from the folder name).
# $2: The absolute path to the directory whose contents (sub-folders and scripts)
#     will be listed as menu options.
display_dynamic_menu() {
    local current_menu_title="$1" # Store the provided menu title
    local path_to_list="$2"       # Store the directory path to explore

# --- Initial Permission Check for the current directory ---
# Before attempting to list contents, ensure the script has read and execute permissions
# for the directory itself. Without 'r', we can't see contents. Without 'x', we can't 'enter' it.
    if [ ! -r "$path_to_list" ] || [ ! -x "$path_to_list" ]; then
        whiptail --msgbox "Error: Insufficient permissions for directory '$path_to_list'. Cannot list contents." "$HEIGHT" "$WIDTH"
        return 0 # Return to the previous menu (or exit if at the root/main menu)
    fi

# --- Main Menu Loop for the Current Level ---
# This 'while true' loop keeps the current menu displayed until the user
# chooses to go "Back", "Exit", or a new sub-menu/script is selected.
    while true; do
        local options=()    # An array to build 'whiptail' menu options ("tag" "description" pairs)
        local item_paths=() # An associative array to map numerical menu index (tag) to the full path of the item
        local i=1           # A counter to assign numerical tags to menu items (1, 2, 3...)

        local all_items=()  # Temporary array to hold all discovered items (files and folders)
                            # before they are sorted and categorized.

        # --- Collect Items (Folders and Files) from the current directory ---
        # `shopt -s nullglob`: This option ensures that if the glob `*` matches no files,
        #                      it expands to nothing, rather than remaining as a literal `*`.
        #                      This prevents errors in the loop if a directory is empty.
        local old_shopt_nullglob=$(shopt -p nullglob) # Save current 'nullglob' setting to restore later
        shopt -s nullglob                              # Enable 'nullglob' for safe globbing

        # Loop through all files and directories directly within the current path.
        # `"$path_to_list"/*` expands to all items.
        for item in "$path_to_list"/*; do
            all_items+=("$item") # Add the full path of each item to the `all_items` array
        done
        eval "$old_shopt_nullglob" # Restore the 'nullglob' setting to its original state

        # --- Sort Items ---
        # `IFS=$'\n'`: Temporarily sets the Internal Field Separator to newline. This is crucial
        #              because `sort` expects each item to be on a new line, and Bash array
        #              expansion normally separates elements by spaces.
        # `sort -V`: Performs a "version sort". This ensures that numbered items are sorted
        #            correctly (e.g., 1, 2, 10, 11 instead of 1, 10, 11, 2).
        # `<<<"${all_items[*]}"`: This is a "here string". It feeds the contents of the `all_items`
        #                          array (expanded into a single string with elements separated by `IFS`)
        #                          as standard input to the `sort` command.
        # `$(...)`: Captures the standard output of the `sort` command into the `sorted_items` array.
        IFS=$'\n' sorted_items=($(sort -V <<<"${all_items[*]}"))
        unset IFS # IMPORTANT: Always unset IFS after using it, to prevent unexpected behavior
                  #            in other parts of the script that rely on default IFS.

        # --- Populate Menu Options for Whiptail (Directories first, then Files) ---
        # This loop adds sub-directories to the `options` array and maps their full paths.
        # Directories are listed first for consistent menu layout.
        for item in "${sorted_items[@]}"; do
            if [ -d "$item" ]; then # Check if the current `item` is a directory
                # Add a menu option: numerical tag ($i) and a descriptive label.
                options+=("$i" "$(basename "$item") [Folder]")
                item_paths[$i]="$item" # Store the full path indexed by its numerical tag
                i=$((i+1))             # Increment the counter for the next item
            fi
        done

        # This loop adds executable script files to the `options` array and maps their full paths.
        # Files are listed after folders.
        for item in "${sorted_items[@]}"; do
            if [ -f "$item" ]; then # Check if the current `item` is a regular file
                # Add a menu option: numerical tag ($i) and a descriptive label.
                options+=("$i" "$(basename "$item") [Script]")
                item_paths[$i]="$item" # Store the full path indexed by its numerical tag
                i=$((i+1))
            fi
        done

        # --- Add "Back" / "Exit" Option ---
        # This conditional determines whether to offer a "Back" option or an "Exit TUI" option.
        if [ "$path_to_list" != "$SCRIPT_DIR" ]; then
            # If we are in a sub-directory (not the main 'scripts' directory), offer "Back".
            options+=("0" "Back to Previous Menu")
        else
            # If we are at the main 'scripts' directory, offer "Exit TUI".
            options+=("0" "Exit TUI")
        fi

        # --- Handle Empty Folders ---
        # If the `options` array only contains the "Back" or "Exit" choice, it means
        # the current directory has no other folders or scripts.
        if [ ${#options[@]} -eq 1 ]; then
             whiptail --msgbox "No scripts or sub-folders found in '$current_menu_title'. Returning to previous menu." "$HEIGHT" "$WIDTH"
             return 0 # Exit this function call, effectively "going back" one level in the menu hierarchy.
        fi

        clear # Clear the terminal screen before displaying the new whiptail menu for this level.

        # --- Display Menu and Get User Choice ---
        CHOICE=$(whiptail --title "$TITLE - $current_menu_title" \
                         --backtitle "$BACKTITLE" \
                         --menu "Select a Folder or a Script to run:" \
                         "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
                         "${options[@]}" 3>&1 1>&2 2>&3) # The famous file descriptor redirection

        local exit_status=$? # Capture the exit status of the `whiptail` command
        if [ "$exit_status" -ne 0 ]; then
            # If the user pressed 'Cancel' or 'Escape', treat it as if they chose option "0" (Back/Exit).
            CHOICE="0"
        fi

        # --- Process User Choice ---
        case "$CHOICE" in
            0)
                # If "0" (Back/Exit) was chosen, exit this function call.
                # If this was the initial call to display_dynamic_menu, the script will then exit.
                # If it was a recursive call, it returns to the previous menu.
                return 0
                ;;
            *)
                # For any other valid choice (a numerical tag corresponding to an item)
                local selected_path="${item_paths[$CHOICE]}" # Retrieve the full path using the chosen tag
                if [ -z "$selected_path" ]; then
                    # Fallback for unexpected selection (e.g., index mismatch, should ideally not happen)
                    whiptail --msgbox "Error: Invalid selection. Item not found or index mismatch. Please try again." "$HEIGHT" "$WIDTH"
                    continue # Stay in the current menu loop
                fi

                # Check if the selected item is a directory or a file
                if [ -d "$selected_path" ]; then
                    # If it's a directory, recursively call `display_dynamic_menu` to descend into it.
                    # This creates the multi-level navigation.
                    display_dynamic_menu "$(basename "$selected_path")" "$selected_path"
                elif [ -f "$selected_path" ]; then
                    # If it's a regular file (assumed to be a script), execute it.
                    # The `run_script` function handles permissions, confirmation, and execution.
                    run_script "$selected_path"
                else
                    # Fallback for unexpected item types (e.g., symlinks, devices, should be rare here)
                    whiptail --msgbox "Error: Item '$selected_path' is neither a folder nor a script. This shouldn't happen." "$HEIGHT" "$WIDTH"
                fi
                ;;
        esac
    done # End of `while true` loop for the current menu level
}


#==================================== Main Script Logic ====================================

clear # Clear the screen before the first menu appears.

# 1. Check initial directory permissions (dependency check now in install_deps.sh)
check_base_dir_permissions

# 2. Set all .sh scripts to executable
find scripts/ -type f -name "*.sh" -exec chmod +x {} \;

# 3. Start the dynamic menu navigation from the root 'scripts' directory
display_dynamic_menu "Main Menu" "$SCRIPT_DIR"

#==================================== Final Exit Messages ====================================
clear
echo "=========================================="
echo "  Thank you for using the Void-Post-Install-Script!   "
echo "=========================================="
echo ""
exit 0
