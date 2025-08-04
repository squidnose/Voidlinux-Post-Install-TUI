#/bin/bash
sudo xbps-install -y remmina

# --- Offer KWallet integration choice ---
echo "Do you want to install 'remmina-kwallet'?"
echo "This plugin integrates Remmina with KDE's KWallet for secure password storage."
echo "It's highly recommended if you use the KDE Plasma desktop environment."
echo ""
read -rp "Install remmina-kwallet? (y/N): " install_kwallet_choice

install_kwallet_choice=${install_kwallet_choice,,} # Convert to lowercase just in case:)

if [[ "$install_kwallet_choice" == "y" || "$install_kwallet_choice" == "yes" ]]; then

        sudo xbps-install -y remmina-kwallet

else
echo "Skipping remmina-kwallet installation."
fi
echo "Remmina installation script finished."


