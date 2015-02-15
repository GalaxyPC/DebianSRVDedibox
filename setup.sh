#!/bin/sh
#
# Simple Firewall script.
#
# Author: Benjamin.COLLEAU@GALAXYPC.fr
wget http://github/firewall.sh
cp firewall.sh firewall
rm -f firewall.sh
chmod u+x firewall
cp firewall /etc/init.d/firewall
