#/bin/bash

cd ~
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
./xbps-src pkg msttcorefonts
sudo xbps-install --repository hostdir/binpkgs/nonfree msttcorefonts
