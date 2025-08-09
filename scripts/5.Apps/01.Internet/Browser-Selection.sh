#!/bin/bash

echo "=================================================="
echo "          Web Browser Installation Script         "
echo "=================================================="
echo ""

echo "This script allows you to install a web browser."
echo "Please choose the browser you wish to install:"
echo ""

# Define browsers and their installation commands
# Using indexed arrays for consistent order
BROWSERS=(
    "Firefox"
    "Vivaldi"
    "Chromium"
    "Lynx (Text-based)"
    "Google Chrome (Flatpak)"
    "Brave Browser (Flatpak)"
    "LibreWolf (Flatpak)"
    "Falkon (Flatpak)"
    "Microsoft Edge (Flatpak)"
    "Mullvad Browser (Flatpak)"
    "Waterfox (Flatpak)"
    "Zen Browser (Flatpak)"
    "Tor Browser (Flatpak)"
)

# Using an associative array for commands, mapping display name to command string
declare -A INSTALL_COMMANDS=(
    ["Firefox"]="sudo xbps-install -y firefox"
    ["Vivaldi"]="sudo xbps-install -y vivaldi"
    ["Chromium"]="sudo xbps-install -y chromium chromium-widevine"
    ["Lynx (Text-based)"]="sudo xbps-install -y lynx"
    ["Google Chrome (Flatpak)"]="flatpak install -y flathub com.google.Chrome"
    ["Brave Browser (Flatpak)"]="flatpak install -y flathub com.brave.Browser"
    ["LibreWolf (Flatpak)"]="flatpak install -y flathub io.gitlab.librewolf-community"
    ["Falkon (Flatpak)"]="flatpak install -y flathub org.kde.falkon"
    ["Microsoft Edge (Flatpak)"]="flatpak install -y flathub com.microsoft.Edge"
    ["Mullvad Browser (Flatpak)"]="flatpak install -y flathub net.mullvad.MullvadBrowser"
    ["Waterfox (Flatpak)"]="flatpak install -y flathub net.waterfox.waterfox"
    ["Zen Browser (Flatpak)"]="flatpak install -y flathub app.zen_browser.zen"
    ["Tor Browser (Flatpak)"]="flatpak install -y flathub org.torproject.torbrowser-launcher"
)

# Display the menu in numerical order
for i in "${!BROWSERS[@]}"; do
    printf "  %2d) %s\n" "$((i+1))" "${BROWSERS[$i]}"
done
printf "  %2d) %s\n" "$(( ${#BROWSERS[@]} + 1 ))" "Exit (go back to main menu)"
echo ""

# Loop until a valid choice is made or user exits
selected_browser_name=""
while true; do
    read -rp "Enter the number of your choice: " choice_num

    # Check for exit option
    if [[ "$choice_num" -eq "$(( ${#BROWSERS[@]} + 1 ))" ]]; then
        echo "Browser installation cancelled."
        exit 0 # Exit the script
    fi

    # Validate choice number and retrieve browser name
    if (( choice_num > 0 && choice_num <= ${#BROWSERS[@]} )); then
        selected_browser_name="${BROWSERS[$((choice_num-1))]}" # Adjust for 0-indexed array
        break
    else
        echo "Invalid choice. Please enter a valid number from the list or the Exit option."
    fi
done

echo "" # Blank line for readability

# --- Execute Installation Based on Choice ---
install_command="${INSTALL_COMMANDS[$selected_browser_name]}"

echo "You chose to install: $selected_browser_name"
echo "Executing command: $install_command"
echo ""

# Check if it's a Flatpak installation
if [[ "$install_command" == flatpak* ]]; then
    if ! command -v flatpak &>/dev/null; then
        echo "Error: 'flatpak' command not found."
        echo "Please install Flatpak first (e.g., 'sudo xbps-install flatpak') and then try again."
        echo ""
        exit 1
    fi
    # Check if flathub remote is added before attempting Flatpak install
    if ! flatpak remotes | grep -q flathub &>/dev/null; then
        echo "It seems the 'flathub' remote might not be added."
        echo "You might need to add it: sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
        echo "Then try installing this browser again."
        echo ""
        exit 1
    fi
elif [[ "$install_command" == sudo\ xbps-install* ]]; then
    if ! command -v xbps-install &>/dev/null; then
        echo "Error: 'xbps-install' command not found. This should not happen on Void Linux."
        echo "Please verify your system's package manager setup."
        echo ""
        exit 1
    fi
fi

# Execute the installation command
eval "$install_command" # Use eval to execute the string as a command

if [ $? -eq 0 ]; then
    echo ""
    echo "$selected_browser_name installation complete!"

    # Specific note for Firefox
    if [ "$selected_browser_name" == "Firefox" ]; then
        echo ""
        echo "Note for Firefox: You may want to install a language pack."
        echo "For that, you can use OctoXBPS or run: sudo xbps-install -S firefox-i18n-<your_language_code>"
        echo "Example for Czech sudo xbps-install -S firefox-i18n-cs"
    fi
else
    echo ""
    echo "Error: $selected_browser_name installation failed."
    echo "Please check the output above for details (e.g., internet connection, repository issues)."
fi

echo "" # Blank line for readability
echo "Browser installation script finished."

# Pause for user to see final messages before returning to main TUI


exit 0
