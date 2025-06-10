#!/bin/bash

# This script runs all other executable scripts found in its current directory.
# It does NOT use whiptail or any TUI elements.

echo "======================================================"
echo " Starting 'Install All' script for this directory ($(basename "$(pwd)"))"
echo "======================================================"
echo ""

# Get the directory where THIS script (e.g., 0.install-all-listed.sh) is located.
CURRENT_SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# --- Collect all executable scripts in the current directory ---
# Removed 'local' keyword here, as this variable is in the global scope of the script.
scripts_to_run=() # Initialize an empty array to store paths of scripts to execute

# Save the current 'nullglob' shell option state and enable it.
# Removed 'local' keyword here.
old_shopt_nullglob=$(shopt -p nullglob)
shopt -s nullglob

# Get all items (files and directories) in the current script's directory.
# Removed 'local' keyword here.
all_items_in_dir=("$CURRENT_SCRIPT_DIR"/*)

# Restore the 'nullglob' setting to its original state immediately after globbing.
eval "$old_shopt_nullglob"

# Sort the collected items (full paths) numerically.
# Removed 'local' keyword here.
IFS=$'\n' sorted_full_paths=($(printf "%s\n" "${all_items_in_dir[@]}" | sort -V))
unset IFS # Unset IFS after use to prevent unintended side-effects later.

# Iterate through the sorted full paths and filter for executable scripts.
for item_full_path in "${sorted_full_paths[@]}"; do
    # 1. Skip if it's not a regular file (e.g., it's a directory, symlink, etc.)
    if [ ! -f "$item_full_path" ]; then
        continue
    fi

    # 2. Skip if the file is this script itself.
    # We compare the basename of the current item with the basename of this script ($0).
    if [ "$(basename "$item_full_path")" = "$(basename "$0")" ]; then
        continue
    fi

    # 3. Skip if the file is not executable.
    # Note: If sudo is required for any sub-script, ensure those sub-scripts handle it internally.
    if [ ! -x "$item_full_path" ]; then
        echo "Skipping non-executable file: $(basename "$item_full_path")" >&2
        continue # Use >&2 to print to standard error, keeping standard output cleaner for scripts.
    fi

    # If all checks pass, add the full path to our list of scripts to run.
    scripts_to_run+=("$item_full_path")
done

# --- Execution Logic ---

if [ ${#scripts_to_run[@]} -eq 0 ]; then
    echo "No other executable scripts found in this directory to run."
else
    echo "The following scripts will be executed in order:"
    for s in "${scripts_to_run[@]}"; do
        echo "- $(basename "$s")"
    done
    echo ""

    # Optional: Simple command-line confirmation before running all of them
    read -rp "Press Enter to start running these ${#scripts_to_run[@]} scripts, or Ctrl+C to cancel... "

    for script_path in "${scripts_to_run[@]}"; do
        echo "=================================================="
        echo "  Running script: $(basename "$script_path")"
        echo "=================================================="

        # Execute the script using its full path.
        "$script_path"

        local exit_code=$? # Capture the exit code of the executed script (this IS inside the loop, so 'local' is fine here)

        if [ "$exit_code" -ne 0 ]; then
            echo "WARNING: Script '$(basename "$script_path")' exited with code $exit_code."
            read -rp "Press Enter to continue with the next script, or Ctrl+C to stop. "
        else
            echo "Script '$(basename "$script_path")' finished successfully."
        fi
        echo "" # Newline for readability between script outputs
    done
    echo "All listed scripts processed."
fi

echo "======================================================"
echo " 'Install All' script finished.                       "
echo "======================================================"

exit 0
