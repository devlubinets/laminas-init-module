#!/bin/bash

while getopts "hv" option;
do
  case $option in
  h) # display Help
    echo "Init shell script - make laminas module form base module template."
    echo "Author: Kyrylo Lybunets"
    echo "Email: dev.lubinets@gmail.com"
    echo "\n"
    echo Arguments:
    echo \$1 - module\'s name
    echo \$2 - ticket on Jira
    echo \$3 - ticket description
    echo \nOptional\n
    echo \$4 - anothet git repo

    echo "\n"

    echo Example:
    echo ./init-module.sh Orm-Super P-31 Description ticket git@dev.lubinets/orm-super.git project-name
    ;;
  v) # show version
    getVersion
    ;;
  *) # default
  esac
  exit;
done