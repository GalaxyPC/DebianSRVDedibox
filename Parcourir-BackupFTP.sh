#!/bin/bash

# @(#) Nom du script .. : parcourir-backupFTP.sh
# @(#) Version ........ : 1.00
# @(#) Date ........... : 16/02/2015
#      Auteurs ........ : GalaxPC.fr

ERROR_FILE=./errors.log
FTP_FILE=./ftp.log


CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CPURPLE="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CBROWN="${CSI}0;33m"

if [[ $EUID -ne 0 ]]; then
    echo ""
    echo -e "${CRED}/!\ ERREUR: Vous devez être connecté en tant que root pour pouvoir exécuter ce script.${CEND}" 1>&2
    echo ""
    exit 1
fi
clear
#######################################################
echo ""
echo -e "${CCYAN}                          Configuration du script backup ${CEND}"
echo ""
echo -e "${CCYAN}
   _____       _                  _____   _____    __      
  / ____|     | |                |  __ \ / ____|  / _|     
 | |  __  __ _| | __ ___  ___   _| |__) | |      | |_ _ __ 
 | | |_ |/ _` | |/ _` \ \/ / | | |  ___/| |      |  _| '__|
 | |__| | (_| | | (_| |>  <| |_| | |    | |____ _| | | |   
  \_____|\__,_|_|\__,_/_/\_\\__, |_|     \_____(_)_| |_|   
                             __/ |                         
                            |___/                          

${CEND}"
echo ""
##########################################################
getCredentials() {
    read -p "> Veuillez saisir l'adresse du serveur ftp : " HOST
    read -p "> Veuillez saisir le numéro du port [Par défaut: 21] : " PORT
    read -p "> Veuillez saisir le nom d'utilisateur : " USER
    read -sp "> Veuillez saisir le mot de passe : " PASSWD
    if [ "$PORT" = "" ]; then
        PORT=21
    fi
    echo -e "\n\nParamètres de connexion :"
    echo -e "- Adresse du serveur : ${CPURPLE}$HOST${CEND}"
    echo -e "- Nom d'utilisateur : ${CPURPLE}$USER${CEND}"
    echo -e "- Port : ${CPURPLE}$PORT${CEND}"
}
getCredentials








exit=0