#!/bin/bash
sudo xbps-install -Syu tlp tlpui
sudo ln -s /etc/sv/tlp /var/service
tlpui

