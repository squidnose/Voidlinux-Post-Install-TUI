#!/bin/bash
sudo xbps-install -Syu power-profiles-daemon
sudo ln /etc/sv/power-profiles-daemon /var/services
