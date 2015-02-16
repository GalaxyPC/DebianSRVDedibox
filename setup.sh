#!/bin/sh
#
# Simple Firewall script.
#
# Author: Benjamin.COLLEAU@GALAXYPC.fr
wget --no-check-certificate https://github.com/GalaxyPC/DebianSRVDedibox/raw/master/firewall.sh
cp firewall.sh firewall
echo "- copie du script en cours..."
rm -f firewall.sh
chmod u+x firewall
echo "- modification des droits d'execution..."
cp firewall /etc/init.d/firewall
echo "Copie vers /etc/init.d/firewall"
rm -f setup.sh firewall
echo "- Demarrage du FireWall.."
service firewall start
exit 0