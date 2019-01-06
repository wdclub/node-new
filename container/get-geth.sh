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

ver=$(curl -L -s https://api.ether1.org/mn/versions.json | jq '.sn.stable' --raw-output)
                                      
URL="https://ether1.org/releases/Ether1-MN-SN-$ver.tar.gz"                         

if [ -f "./limits.conf" ]; then 
    if grep "NODE_BINARY=" "./limits.conf"; then 
        NODE_BINARY=$(grep "NODE_BINARY=" "./limits.conf" | sed 's/NODE_BINARY=//g')
        if [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=geth-etho

case "$URL" in
    *.tar.gz) 
        curl -L "$URL" -o "./$FILE.tar.gz"
        tar -xzvf "./$FILE.tar.gz"
        rm -f "./$FILE.tar.gz"
    ;;
    *.zip)
        curl -L "$URL" -o "./$FILE.zip"
        unzip "./$FILE.zip"
        rm -f "./$FILE.zip"
    ;;
esac

cp -f "$(find . -name geth)" . 2>/dev/null || exit 0