#!/bin/sh
#
# Simple Firewall script.
#
# Author: Benjamin.COLLEAU@GALAXYPC.fr
#
# chkconfig: 2345 9 91
# description: Script IPTABLES/FIREWALL Debian dédiBox
#
### BEGIN INIT INFO
# Provides: firewall.sh
# Required-Start: $syslog $network $remote_fs
# Required-Stop: $syslog $network $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start firewall daemon at boot time
# Description: Firewall script.
### END INIT INFO
PATH=/bin:/sbin:/usr/bin:/usr/sbin
############# CONFIGURATION IPTABLES #############
# Activitation du Firewall : yes/no
FW_ACTIVE=yes
# interface internet
IFACE_INET=eth0
#################################################
# initialisation des variables
IPT=$(which iptables)
SYS=$(which sysctl)

case "$1" in
start)
#################################################
# Verification fw activé ou non
if [ $FW_ACTIVE != "yes" ]; then
  echo "\033[31m!!! Firewall desactivé dans firewall.sh !!!\033[0m"
  exit 0
fi
###########################################
echo -n "- Initialisation du firewall :"
$IPT -F 2>/dev/null
echo "\033[32m [OK] \033[0m"
#
echo -n "- Vidage des regles et des tables :"
$IPT -X 2>/dev/null
echo "\033[32m [OK] \033[0m"
#
echo -n "- Interdire toutes les connexions entrantes :"
$IPT -t filter -P INPUT DROP
$IPT -t filter -P FORWARD DROP
$IPT -t filter -P OUTPUT DROP
echo "\033[32m [OK] \033[0m"
#
# Désactiver le partage de connexion
# $SYS -q -w net.ipv4.ip_forward=0
$IPT -A INPUT -j LOG --log-prefix "+++ IPv4 packet rejected +++ "
# Partage de connexion
#if [ $FW_MASQ = 'yes' ]; then
#  $IPT -t nat -A POSTROUTING -o $IFACE_INET -s $IFACE_LAN_IP -j MASQUERADE
#  $SYS -q -w net.ipv4.ip_forward=1
#fi
###########################################

## Permettre à une connexion ouverte de recevoir du trafic en entrée.
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
## Permettre à une connexion ouverte de recevoir du trafic en sortie.
$IPT -A OUTPUT -m state ! --state INVALID -j ACCEPT
echo "- Ne pas casser les connexions établies :" "\033[32m [OK] \033[0m"
#-------- Regles --------#
echo "### Debut d'activation des rêgles personalisées ###"
# On accepte la boucle locale en entrée.
$IPT -t filter -A INPUT -i lo -j ACCEPT
$IPT -t filter -A OUTPUT -o lo -j ACCEPT
# Autoriser le ping (Protocole ICMP)
$IPT -t filter -A INPUT -p icmp -j ACCEPT
$IPT -t filter -A OUTPUT -p icmp -j ACCEPT
# Autoriser SSH (Conseil de modif le port ici et dans /etc/ssh/sshd_config !!)
$IPT -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
# Autoriser DNS
$IPT -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
$IPT -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
$IPT -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
$IPT -t filter -A INPUT -p udp --dport 53 -j ACCEPT
# Autoriser NTP
$IPT -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
# Autoriser FTP
modprobe ip_conntrack_ftp # ligne facultative avec les serveurs OVH
$IPT -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT
$IPT -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
# Autoriser HTTP et HTTPS
$IPT -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
$IPT -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
$IPT -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
$IPT -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT
# Autoriser SMTP:25
$IPT -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
# Mail POP3:110
$IPT -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
# Mail IMAP:143
$IPT -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
# Mail POP3S:995
$IPT -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
# Autoriser Prise en main a distance bureau VNC
# iptables -t filter -A INPUT -p tcp --dport 5901 -j ACCEPT
# iptables -t filter -A OUTPUT -p tcp --dport 5901 -j ACCEPT
# Monit
$IPT -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT
# RPS OVH, utile pour disque iSCSI
# iptables -A OUTPUT -p tcp --dport 3260 -m state --state NEW,ESTABLISHED -j ACCEPT
echo "- Initialisation des règles :" "\033[32m [OK] \033[0m"
# Autoriser Shoutcast
$IPT -t filter -A INPUT -p tcp --dport 8000:8003 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 8000:8003 -j ACCEPT
echo "- Shoutcast regles :" "\033[32m [OK] \033[0m"
# Autorise seedbox
$IPT -t filter -A INPUT -p tcp --dport 9091 -j ACCEPT
$IPT -t filter -A OUTPUT -p tcp --dport 9091 -j ACCEPT
echo "- SeedBox regles :" "\033[32m [OK] \033[0m"
#
echo "### Redémarrage de Fail2ban... ###"
[ -e /etc/init.d/fail2ban ] && /etc/init.d/fail2ban restart
echo "### Firewall.sh" "\033[32m [OK] \033[0m""###"
exit 0
;;
status)
echo - Liste des regles :
iptables -n -L
;;
stop)
# Vidage des tables et des regles personnelles
iptables -t filter -F
iptables -t filter -X
echo "- Vidage des regles et des tables : \033[32m [OK] \033[0m"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
echo "- Autoriser toutes les connexions entrantes et sortantes : \033[32m [OK] \033[0m"
;;
esac
exit 0