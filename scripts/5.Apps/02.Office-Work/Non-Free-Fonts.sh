#/bin/bash
if whiptail --title "Compile Nonfree Fonts from Microsoft?" --yesno "This can take a long time(15-60 minutes)\nDo you Wish to proceede?" 15 60; then
cd ~
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
./xbps-src pkg msttcorefonts
sudo xbps-install --repository hostdir/binpkgs/nonfree msttcorefonts
fi
exit 0
