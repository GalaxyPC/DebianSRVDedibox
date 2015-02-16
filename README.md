# DebianSRVH-berg-
Script Linux Debian pour serveur hébergé
> Firewall.sh & setup.sh
Ce script me permet rapidement importer mes regles iptables.

INSTALLATION:
# wget --no-check-certificate https://raw.githubusercontent.com/GalaxyPC/DebianSRVDedibox/664a01703c062cca65daa7a65d4be0a7050609e9/setup.sh
# chmod u+x setup.sh
# ./setup.sh

Vous pouvez modifier ensuite les regles dans /etc/init.d/firewall avec l'editeur texte que vous preferez.

Fonctionnement du service Firewall:
# service firewall start|status|stop

Desinstallation se fait en supprimant le script:
# service firewall stop
# rm -f /etc/init.d/firewall
# update-rc.d -f firewall remove