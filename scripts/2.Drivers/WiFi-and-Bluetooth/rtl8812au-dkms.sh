#!/bin/bash
sudo xbps-install -Syu rtl8812au-dkms
sudo usermod -aG network "$USER"



