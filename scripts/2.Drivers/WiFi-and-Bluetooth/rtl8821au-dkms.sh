#!/bin/bash
sudo xbps-install -Syu rtl8821au-dkms
sudo usermod -aG network "$USER"



