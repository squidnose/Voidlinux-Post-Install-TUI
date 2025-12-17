#!/bin/bash
echo "Waydroid - Intel or AMD (or Nvidia with Nouveau drivers)"
sudo xbps-install waydoid python3-pyclip wl-clipboard
sudo ln -s /etc/sv/waydroid-container /var/service
echo "To make google apps, like google play store to work:"
echo "Restart your machine"
echo "open waydroid"
echo "install the GAPPS version"
echo "sign in to you google accout"
echo "go to this site and get a adroid ID number"
echo "close waydroid and open terminal konsole"
echo "in the terminal open the Waydroid shell:"
echo "sudo waydroid shell"
echo "to enter the ID, find the command on this website:"
echo "https://docs.waydro.id/faq/google-play-certification"
