#!/bin/bash
sudo xbps-install -Syu rtl8822bu-dkms
sudo usermod -aG network "$USER"



