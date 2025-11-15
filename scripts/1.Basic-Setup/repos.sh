#/bin/bash
echo "Synchronize and Update:"
sudo xbps-install -Syu
echo "Adding 32 bit repos (Will fail on musl)"
sudo xbps-install void-repo-multilib void-repo-multilib-nonfree
echo "Adding the Nonfree repo"
sudo xbps-install -Syu void-repo-nonfree
echo "Synchronizeing and Update:"
sudo xbps-install -Syu

echo "installing flatpak"
sudo xbps-install -Syu flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "If it failed, you will need to re-reun this script after you setup dbus and a grapphical session."
