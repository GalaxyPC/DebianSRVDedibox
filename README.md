# DebianSRVH-berg-
Script Linux Debian pour serveur hébergé
```shell
Firewall.sh & setup.sh
```
Ce script me permet rapidement importer mes regles iptables.

# 1.INSTALLATION:
Vous devez etre connecté en tant que root !
```shell
wget --no-check-certificate https://raw.githubusercontent.com/GalaxyPC/DebianSRVDedibox/master/setup.sh
chmod u+x setup.sh
./setup.sh
```
#2.Vous pouvez modifier ensuite les regles dans /etc/init.d/firewall avec l'editeur texte que vous preferez.

#3.Fonctionnement du service Firewall:
```shell
service firewall start|status|stop
```

#4.Desinstallation se fait en supprimant le script:
```shell
service firewall stop
rm -f /etc/init.d/firewall
update-rc.d -f firewall remove
```
