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

GIT_INFO=$(curl -sL "https://api.github.com/repos/Ether1Project/Ether-1-GN-Binaries/releases/latest")                                       
URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep ethoFS)                        

if [ -f "./limits.conf" ]; then 
    if grep "ETHOFS_VERSION=" "./limits.conf"; then 
        NODE_BINARY=$(grep "ETHOFS_VERSION=" "./limits.conf" | sed 's/ETHOFS_VERSION=//g')
       
        if curl --fail -sL "https://api.github.com/repos/Ether1Project/Ether-1-GN-Binaries/releases/tags/$NODE_BINARY"; then
            GIT_INFO=$(curl -sL "https://api.github.com/repos/Ether1Project/Ether-1-GN-Binaries/releases/tags/$NODE_BINARY")                                       
            URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep ethoFS)                         
        elif [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=crown

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

cp -f "$(find . -name ethoFS)" . 2>/dev/null
mv ./ethoFS /usr/sbin/ethoFS
chmod +x /usr/sbin/ethoFS

printf "%s" "$(printf "%s" "$GIT_INFO" | jq .tag_name -r | sed 's\v\\')" > ./version

exit 0