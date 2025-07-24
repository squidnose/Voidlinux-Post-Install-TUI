#!bin/bash
echo "Tento Script informuje, není to funkčí."
echo "Zde máš seznam lokálu"
locale -a
echo "Otevři soubor sudo nano /etc/default/libc-locales"
echo "najdi řádek #cs_CZ.UTF-8 UTF-8"
echo "Změň ho na tohle: cs_CZ.UTF-8 UTF-8"
echo "Následně regenerus lokály: sudo xbps-reconfigure -f glibc-locales"
