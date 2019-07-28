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
    GE)
        if [ -f "$BASEDIR/../docker-compose.override.ge.yml" ] && [ "$VALUE_FOR_SED" = "true" ]; then
            mv "$BASEDIR/../docker-compose.override.ge.yml" "$BASEDIR/../docker-compose.override.yml"
        fi
    ;;
    GE_PORT)
        TARGET_FILE="$BASEDIR/../docker-compose.override.ge.yml"
        if [ ! -f "$BASEDIR/../docker-compose.override.ge.yml" ]; then
            TARGET_FILE="$BASEDIR/../docker-compose.override.yml"
        fi
        NEW_COMPOSE=$(sed "s/- \".*:9090\"/- \"$VALUE_FOR_SED:9090\"/g" "$TARGET_FILE")
        echo "$NEW_COMPOSE" > "$TARGET_FILE"
    ;;
esac