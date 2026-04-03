#!/bin/bash
sudo xbps-install -Syu rtl8821cu-dkms
sudo usermod -aG network "$USER"



