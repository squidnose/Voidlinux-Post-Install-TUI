#/bin/bash
echo "Install and configure QEMU/KVM + virt manager + LXC:"
sudo xbps-install -y virt-manager qemu lxc bridge-utils iptables edk2-ovmf
sudo ln -s /etc/sv/libvirtd /var/service
sudo ln -s /etc/sv/virtlockd /var/service
sudo ln -s /etc/sv/virtlogd /var/service
sudo usermod -aG libvirt $USER



