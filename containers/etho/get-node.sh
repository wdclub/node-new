#!/bin/sh

GIT_INFO=$(curl -sL "https://api.github.com/repos/Ether1Project/Ether1/releases/latest")                                       
URL=$(printf "%s" "$GIT_INFO" | jq .assets[].browser_download_url -r)                        

for row in $URL; do 
    if basename "$row" | grep Ether1 > /dev/null; then 
        URL="$row"
    fi 
done

if [ -f "./limits.conf" ]; then 
    if grep "NODE_VERSION=" "./limits.conf"; then 
        NODE_BINARY=$(grep "NODE_VERSION=" "./limits.conf" | sed 's/NODE_VERSION=//g')
       
        if curl --fail -sL "https://api.github.com/repos/Ether1Project/Ether1/releases/tags/$NODE_BINARY"; then
            GIT_INFO=$(curl -sL "https://api.github.com/repos/Ether1Project/Ether1/releases/tags/$NODE_BINARY")                                       
            URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r)      
            for row in $URL; do 
                if basename "$row" | grep Ether1 > /dev/null; then 
                    URL="$row"
                fi 
            done                    
        elif [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=geth

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

cp -f "$(find . -name geth)" . 2>/dev/null

printf "%s" "$(printf "%s" "$GIT_INFO" | jq .tag_name -r | sed 's\v\\')" > ./version

exit 0

