#!/bin/bash
sudo xbps-install -Syu NetworkManager dbus elogind
for svc in NetworkManager dbus elogind; do
    sudo ln -sf /etc/sv/$svc /var/service/
done

echo "diabling acpid"
sudo rm /var/service/acpid
