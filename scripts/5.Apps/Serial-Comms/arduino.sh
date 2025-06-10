#!/bin/bash

# --- Incorrect prompt, but keeping it as per your script for minimal changes ---
echo "What version of Arduino IDE do you want?"
echo "1. Arduino IDE and Arduino CLI 1.8 (XBPS)"
echo "2. Arduino IDE 1.8 (Flatpak)"
echo "3. Arduino IDE 2.x (Flatpak)"
read -rp "What version do you want? (1,2,3): " arduino_version # <-- FIX THIS PROMPT LATER

# Arduino 1.8 xbps
if [[ "$arduino_version" == "1" ]]; then
    sudo xbps-install -y arduino arduino-cli

# Arduino 1.8 flatpak
elif [[ "$arduino_version" == "2" ]]; then # <-- Changed 'else if' to 'elif'
    flatpak install flathub cc.arduino.arduinoide

# Arduino 2.X flatpak
elif [[ "$arduino_version" == "3" ]]; then # <-- Changed condition to '3' and 'elif'
    flatpak install flathub cc.arduino.IDE2

else # <-- This 'else' now correctly catches invalid inputs
    echo "Invalid choice. No Arduino IDE version installed."
fi # <-- Closes the main if/elif/else block

echo "Arduino installation script finished."
echo "Run Allow-Serial-Comms-Dialout.sh or add yourself to dialout to use"
