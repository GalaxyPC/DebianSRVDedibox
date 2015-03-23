#!/bin/bash
#
# Setup for my Firewall script.
#
# Author: Benjamin.COLLEAU@GALAXYPC.fr
### Variables couleurs ###
CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CPURPLE="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CBROWN="${CSI}0;33m"

ERROR_FILE=./errors.log

####### Verification root ########
if [[ $EUID -ne 0 ]]; then
    echo ""
    echo -e "${CRED}/!\ ERREUR: Vous devez être connecté en tant que root pour pouvoir exécuter ce script.${CEND}" 1>&2
    echo ""
    exit 1
fi
clear
########## WAIT ##########
smallLoader() {
    echo ""
    echo ""
    echo '[ + + +             ] 3s \r'
    sleep 1
    echo '[ + + + + + +       ] 2s \r'
    sleep 1
    echo '[ + + + + + + + + + ] 1s \r'
    sleep 1
    echo '[ + + + + + + + + + ] Appuyez sur [ENTRÉE] pour continuer... \r'
    echo '\n'

    read
}
#######################################################

echo ""
echo "${CCYAN}                          Configuration du script Firewall ${CEND}"
echo ""
echo "${CRED}GALXAYPC.fr@Benjamin COLLEAU${CEND}"
echo "${CCYAN}${CEND}"
echo "${CCYAN}   _____       _                  _____   _____    __      ${CEND}"
echo "${CCYAN}  / ____|     | |                |  __ \ / ____|  / _|     ${CEND}"
echo "${CCYAN} | |  __  __ _| | __ ___  ___   _| |__) | |      | |_ _ __ ${CEND}"
echo "${CCYAN} | | |_ |/ _` | |/ _` \ \/ / | | |  ___/| |      |  _| '__|${CEND}"
echo "${CCYAN} | |__| | (_| | | (_| |>  <| |_| | |    | |____ _| | | |   ${CEND}"
echo "${CCYAN}  \_____|\__,_|_|\__,_/_/\_\\__, |_|     \_____(_)_| |_|   ${CEND}"
echo "${CCYAN}                             __/ |                         ${CEND}"
echo "${CCYAN}                            |___/                          ${CEND}"
echo ""
echo "##########################################################"
echo "${CGREEN}-> Téléchargement firewall.sh ${CEND}"
echo ""
wget --no-check-certificate https://raw.githubusercontent.com/GalaxyPC/DebianSRVDedibox/master/firewall.sh
echo "- copie du script en cours..."
cp firewall.sh firewall
rm -f firewall.sh
echo "${CGREEN}-> modification des droits d'execution... ${CEND}"
echo ""
chmod u+x firewall
echo "- Copie vers /etc/init.d/firewall"
cp firewall /etc/init.d/firewall
rm -f setup.sh firewall
echo "- Mise à jour de votre Debian"
apt-get update && apt-get upgrade --force-yes
echo "${CGREEN}-> Démarrage du FireWall ${CEND}"
echo ""
update-rc.d firewall defaults
service firewall start
smallLoader
echo "${CCYAN}---------------------------------${CEND}"
echo "${CCYAN}[       STATUS FIREWALL         ]${CEND}"
echo "${CCYAN}---------------------------------${CEND}"
echo ""
service firewall status
exit 0
