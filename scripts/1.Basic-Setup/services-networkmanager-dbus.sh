#!/bin/bash
sudo xbps-install -Syu NetworkManager dbus
for svc in NetworkManager dbus; do
    sudo ln -sf /etc/sv/$svc /var/service/
done

