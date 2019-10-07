#!/bin/sh

#  ETHER-1 Service Node docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com


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
    ETHOFS_VERSION)
        if grep "ETHOFS_VERSION=" "$BASEDIR/../containers/ethofs/limits.conf"; then
            TEMP=$(sed "s/ETHOFS_VERSION=.*/ETHOFS_VERSION=$VALUE_FOR_SED/g" "$BASEDIR/../containers/ethofs/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/ethofs/limits.conf"
        else 
            printf "\nETHOFS_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/ethofs/limits.conf"
        fi
    ;;
    IPFS_VERSION)
        if grep "IPFS_VERSION=" "$BASEDIR/../containers/ethofs/limits.conf"; then
            TEMP=$(sed "s/IPFS_VERSION=.*/IPFS_VERSION=$VALUE_FOR_SED/g" "$BASEDIR/../containers/ethofs/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/ethofs/limits.conf"
        else 
            printf "\nIPFS_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/ethofs/limits.conf"
        fi
    ;;
    bootstrap)
        TEMP=$(sed "s/BOOTSTRAP_URL=.*/BOOTSTRAP_URL=\"$VALUE_FOR_SED\"/g" "$BASEDIR/before-start.sh")
        printf "%s" "$TEMP" > "$BASEDIR/before-start.sh"
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