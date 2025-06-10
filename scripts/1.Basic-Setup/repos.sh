#/bin/bash
echo "Aktualizovat a Přidat Repozitáře: 32 bit, Non-free, Non-free-32 bit, Flathub?"
#read -p "Zmáčkni enter k instalaci, CTRL+c k zrušení"

echo "Synchronize and Update:"
sudo xbps-install -Syu
echo "Adding Repos"
sudo xbps-install void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "Synchronizeing and Update:"
sudo xbps-install -Syu

echo "installing flatpak"
sudo xbps-install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
