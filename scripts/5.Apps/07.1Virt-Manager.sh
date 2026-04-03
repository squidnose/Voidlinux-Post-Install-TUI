#!/bin/bash
if whiptail --title "QEMU/KVM Virt Manager" --yesno "Do you wish to: Install and configure QEMU/KVM + virt manager + LXC:" 15 60; then
echo "Install and configure QEMU/KVM + virt manager (LXC Not ye working):"
sudo xbps-install -Sy virt-manager qemu lxc bridge-utils iptables edk2-ovmf swtpm
sudo ln -s /etc/sv/libvirtd /var/service
sudo ln -s /etc/sv/virtlockd /var/service
sudo ln -s /etc/sv/virtlogd /var/service
sudo usermod -aG libvirt $USER
fi

