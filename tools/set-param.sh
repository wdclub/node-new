#!/bin/sh

BASEDIR=$(dirname "$0")

PARAM=$(echo "$1" | sed "s/=.*//")
VALUE=$(echo "$1" | sed "s/[^>]*=//")
# escape value for sed
VALUE_FOR_SED=$(echo "$VALUE" | sed -e 's/[\/&]/\\&/g')

case $PARAM in
    NODE_VERSION) 
        if grep "NODE_VERSION=" "$BASEDIR/../containers/etho/limits.conf"; then
            TEMP=$(sed "s/NODE_VERSION=.*/NODE_VERSION=$VALUE_FOR_SED/g" "$BASEDIR/../containers/etho/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/etho/limits.conf"
        else 
            printf "\nNODE_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/etho/limits.conf"
        fi
    ;;
    PROJECT)
        printf "PROJECT=%s" "$VALUE" >  "$BASEDIR/../project_id"
    ;;
    ip)
        TEMP=$(sed "s/EXTERNAL_IP=.*/EXTERNAL_IP=$VALUE_FOR_SED/g" "$BASEDIR/../.env")
        printf "%s" "$TEMP" > "$BASEDIR/../.env"
    ;;
    IP)
        TEMP=$(sed "s/EXTERNAL_IP=.*/EXTERNAL_IP=$VALUE_FOR_SED/g" "$BASEDIR/../.env")
        printf "%s" "$TEMP" > "$BASEDIR/../.env"
    ;;
esac
