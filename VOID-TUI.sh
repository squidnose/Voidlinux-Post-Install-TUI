#!/bin/bash
set -e

# This code has parts from:
# Linux-Scritp-Runner https://codeberg.org/squidnose-code/Linux-Script-Runner
# Abriviated to LSR

#================ 0 - Dependecy Check ================
## Ensure whiptail exists
if ! command -v whiptail >/dev/null 2>&1; then
   echo "Whiptail not found, attempting to install the newt package:"
   sudo xbps-install -Syu xbps
   sudo xbps-install -Syu newt
fi

#================  1 - Parameters ================
# Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

# SCRIPT_DIR points to the base directory
SCRIPT_DIR="$(dirname "$(realpath "$0")")/scripts"

# Directory to store config and logs files
mkdir -p "$HOME/.local/state/VOID-TUI"

# Title
TITLE="Void-Post-Install-Script GIT" # Main title
BACKTITLE="Select and Item" # appears in top-left

#================  2 - Newt Color Themes ================
# Color of the TUI
## if no color file found, Set default to Matrix Green,
## Colors are changeable in TUI-Settings.sh
NEWT_COLORS_FILE="$HOME/.local/state/VOID-TUI/colors.conf"
if [ -f "$NEWT_COLORS_FILE" ]; then
    export NEWT_COLORS_FILE
else
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
export NEWT_COLORS_FILE
whiptail --msgbox "Colors set to Matrix Green.\nYou can later change this in Settings" "$HEIGHT" "$WIDTH"
fi

#================  3 - Side Functions ================
# Save Config file choices
change_conf_file()
{
if whiptail --title "$TITLE - loggs" --yesno "Do you wish to have loggs enabled?" $HEIGHT $WIDTH; then
    loggs="true"
else
    loggs="false"
fi

cat > "$VOID_TUI_CONF" <<EOF
loggs="$loggs"
EOF

}
# Load Config file to read is user wants logs or not
## If not existing, make a new one
VOID_TUI_CONF="$HOME/.local/state/VOID-TUI/VOID-TUI.conf"
if [ -f "$VOID_TUI_CONF" ]; then
    source "$VOID_TUI_CONF"
else
    change_conf_file
fi

# Log what happens in TUI
LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"

# Echo into terminal, then log into file (if logs are enabled )
echlog()
{
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}

#================ 4 - LSR Functions ================
# Check initial SCRIPT_DIR permissions and existence
check_base_dir_permissions() {

    ## Check if directory exists
    if [ ! -d "$SCRIPT_DIR" ]; then
        echlog "Error: The directory '$SCRIPT_DIR' does not exist." >&2
        echlog "It should contain your script files." >&2
        exit 1
    fi

    ## Check read permission
    if [ ! -r "$SCRIPT_DIR" ]; then
        echlog "Error: You do not have READ permission for '$SCRIPT_DIR'." >&2
        echlog "Use: chmod u+r \"$SCRIPT_DIR\"" >&2
        exit 1
    fi

    ## Check execute permission
    if [ ! -x "$SCRIPT_DIR" ]; then
        echlog "Error: You do not have EXECUTE permission for '$SCRIPT_DIR'." >&2
        echlog "Use: chmod u+x \"$SCRIPT_DIR\"" >&2
        exit 1
    fi
}

# Generic Function to run a script
run_script() {
    ## The full path to the script to run (passed as argument $1).
    local script_path="$1"

    ## Extract the script's file name from the full path.
    local script_name="$(basename "$script_path")"

    ## Check if the script file actually exists
    if [ ! -f "$script_path" ]; then
        whiptail --msgbox "Error: Script '$script_name' not found at '$script_path'. How did you do that... LOL" "$HEIGHT" "$WIDTH"
        return 1
    fi

    ## Executable permissions check
    if [ ! -x "$script_path" ]; then
        whiptail --msgbox "Script '$script_name' is not executable. Attempting to add permissions..." "$HEIGHT" "$WIDTH"
        chmod +x "$script_path"
        if [ $? -ne 0 ]; then ### Grab the exit status of the previous command(chmod) if failed then message
            whiptail --msgbox "Error: Failed to make '$script_name' executable. Cannot run. Check your permissions." "$HEIGHT" "$WIDTH"
            return 1
        fi
    fi

## Confirmation Logic
    if ! (whiptail --title "Confirm Run" --yesno "Are you sure you want to run '$script_name'?" 10 60); then
        echlog "User cancelled running '$script_name'." >&2
        return 0 ### User chose not to run, return to menu
    fi

## Script Execution
    echlog "=========================================="
    echlog "Running $script_path"
    "$script_path"
    echlog "Ran $script_path"
    echlog "=========================================="
    read -p "Done, press enter to continue"
    return 0
}

#Display menu logic
#What does it do:
    #scan directories
    #build dynamic menus
    #handle navigation
    #read text files
    #manage exit logic
    #Filters directory items

display_dynamic_menu() {
    ### 1. Parameters
    local title="$1"
    local current_path="$2"
    local original_path="$2" # Keep track of the original starting path

    ### 2. Main menu loop (runs until user exits)
    while true; do

    ## Detect terminal size
    TERM_HEIGHT=$(tput lines)
    TERM_WIDTH=$(tput cols)
    ## Set TUI size based on terminal size
    HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
    WIDTH=$(( TERM_WIDTH * 4 / 5 ))
    MENU_HEIGHT=$(( HEIGHT - 10 ))

    ### 3. Build dynamic menu options based on current folder
    local menu_options=()

        ### Add "Go back" option unless we're at the root of the script directory.
        ### This provides a way to navigate up a level in the folder structure.
        if [[ "$current_path" != "$original_path" ]]; then
            menu_options+=("..-back" "Go back to the previous menu")
        fi

    ### 4. Find folders, scripts, and text files in the current directory.
        ### I use find with -maxdepth 1 to only look in the current directory.
        ### Finds all files that are either .sh or not .sh.
        ### This output is then sorted into .sh and non .sh files/folders.
        local items
        items=$(find "$current_path" -maxdepth 1 -mindepth 1 \( -type d -o -type f -name "*.sh" -o -type f ! -name "*.sh" \) | sort)

    ### 5. Process each item found and add it to our menu options array.
        while read -r item; do # Reads one line at a time from the input
            local item_name
            item_name=$(basename "$item")

        ### If the item is a directory, add it to the menu with a label indicating it's a folder.
            if [ -d "$item" ]; then
                menu_options+=("$item_name" "(Folder) Enter this folder")

        ### If the item is a script with a '.sh' extension, add it to the menu with a script label.
            elif [ -f "$item" ] && [[ "$item_name" == *.sh ]]; then
                menu_options+=("$item_name" "(Script) Run this script")

        ### If the item is a file but not a '.sh' script, we'll assume it's a text file to be read.
           elif [ -f "$item" ]; then
                menu_options+=("$item_name" "(File) Read this file")
            fi
        done <<< "$items" # The loop runs once for each path found by find.

        # Add an "Exit" option to the menu. This option is be available at all levels.
        menu_options+=("Exit" "Go back to the Main menu")


    ### 6. Display the Menu
        # Use whiptail to display the menu to the user.
        # The user's selection is stored in the 'choice' variable.
        local choice
        choice=$(whiptail --title "$TITLE" --backtitle "$BACKTITLE" \
                          --menu "$title" "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
                          "${menu_options[@]}" 3>&1 1>&2 2>&3)

        ### Check the exit status of whiptail.
        ### If it's not 0, it breaks the loop.
        ### In the case the user pressed Escape.
        if [ $? -ne 0 ]; then
            break
        fi

        ### Process the user's choice based on the selected option.
        if [[ "$choice" == "Exit" ]]; then
            ### Return to main menu
            return 0
        ### The user chose to go back. We update the current path to the parent directory.
        elif [[ "$choice" == "..-back" ]]; then

            current_path=$(dirname "$current_path") #Goes back using dirname
            title="Go Back" # Updates the title for the next menu display.
       ### Run a script
       else
            local chosen_path="$current_path/$choice" # Reconstructs the full path of what the user selected.

            ### For folders, the path is updated
            if [ -d "$chosen_path" ]; then
                current_path="$chosen_path"
                title="Inside: $choice" # Update the title to reflect the new location.
            ### For .sh files, the run_script funciton is called with the path parsed
            elif [ -f "$chosen_path" ] && [[ "$chosen_path" == *.sh ]]; then
                run_script "$chosen_path"
            ### For Files to read using less
            elif [ -f "$chosen_path" ]; then
                less "$chosen_path"
                # The script will continue after 'less' is closed by the user (by pressing 'q').
            ### Fallback for when a selected file or folder is no longer available.
            else
                whiptail --msgbox "Error: '$choice' could not be found or is not a valid script." "$HEIGHT" "$WIDTH"
            fi
        fi
    done
}


#==================================== Main Script Logic ====================================

# 1. Prep
clear # Clear the screen before the first menu appears.
echlog "=========================================="
echlog " Debug Output, please check for any errors:"
echlog "=========================================="
# Check initial directory permissions (dependency check now in install_deps.sh)
check_base_dir_permissions

# Set all .sh scripts to executable
find scripts/ -type f -name "*.sh" -exec chmod +x {} \;

# 2. Main Menu

while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose:" $HEIGHT $WIDTH $MENU_HEIGHT \
    "Scripts"       "Choose What to run" \
    "Setup"         "Assisted Setup" \
    "Maintenance"   "Updates and Clean Up" \
    "Settings"      "Change TUI Color and Logs" \
    "x"             "exit" \
    3>&1 1>&2 2>&3)
    case "$CHOICE" in
    Scripts) display_dynamic_menu "Main Menu" "$SCRIPT_DIR";;
    Setup) bash "Setup-Wizard.sh" ;;
    Maintenance) bash "$SCRIPT_DIR/0.Info-Tools/3.Voidlinux-Maintenance.sh" ;;
    Settings) bash "TUI-Settings.sh";;
    *)
        echlog "=========================================="
        echlog "  Thank you for using My Voidlinux-Post-Install-TUI!   "
        echlog "=========================================="
        read -p "Press Enter To continue"
        exit 0
    ;;
    esac
done

exit 0
