#!/bin/bash
sudo usermod -aG wheel,floppy,dialout,audio,video,cdrom,optical,kvm,users,xbuilder,network "$USER"
