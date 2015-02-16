#!/bin/sh
#
# Setup for my Firewall script.
#
# Author: Benjamin.COLLEAU@GALAXYPC.fr
wget --no-check-certificate wget --no-check-certificate https://raw.githubusercontent.com/GalaxyPC/DebianSRVDedibox/master/firewall.sh
cp firewall.sh firewall
echo "- copie du script en cours..."
rm -f firewall.sh
chmod u+x firewall
echo "- modification des droits d'execution..."
cp firewall /etc/init.d/firewall
echo "- Copie vers /etc/init.d/firewall"
rm -f setup.sh firewall
echo "- Demarrage du FireWall..."
update-rc.d firewall defaults
service firewall start
echo "- STATUS du FireWall:"
service firewall status
exit 0