#/bin/bash
sudo xbps-install -y kdeconnect
echo "If you use ufw you may need to run:"
echo "sudo ufw allow 1714:1764/udp"
echo "sudo ufw allow 1714:1764/tcp"
echo "sudo ufw reload"
echo "Then Resrart and reload KdeConnect"

