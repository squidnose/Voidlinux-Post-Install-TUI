#!/bin/bash
sudo xbps-install -Syu power-profiles-daemon
sudo ln -s /etc/sv/power-profiles-daemon /var/services

