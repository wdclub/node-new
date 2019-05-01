#!/bin/sh
set -e

IFS='
'

term_handler() {
    echo "Handling termination..."
    LAST_SOURCE=$(sed 's/=.*//g' /mapped-ip)
    SOURCE=$(sed 's/=.*//g' /map-ip)
    if [ -n "$LAST_SOURCE" ]; then
        for rule in $(iptables-save -t nat | grep -- "-A POSTROUTING -s $LAST_SOURCE/32 -j SNAT --to-source"); do 
            echo "iptables -t nat $(printf "%s" "$rule" | sed 's/-A/-D/g')"
            eval "iptables -t nat $(printf "%s" "$rule" | sed 's/-A/-D/g')"
        done
    fi
    if [ -n "$SOURCE" ]; then
        for rule in $(iptables-save -t nat | grep -- "-A POSTROUTING -s $SOURCE/32 -j SNAT --to-source"); do 
            echo "iptables -t nat $(printf "%s" "$rule" | sed 's/-A/-D/g')"
            eval "iptables -t nat $(printf "%s" "$rule" | sed 's/-A/-D/g')"
        done
    fi
    printf "0.0.0.0=0.0.0.0" > /mapped-ip
    exit 143; # 128 + 15 -- SIGTERM
}

trap 'term_handler' TERM

while true; do
    sleep 5
    if [ -f "/map-ip" ]; then 
        SOURCE=$(sed 's/=.*//g' /map-ip)
        TARGET=$(sed 's/.*=//g' /map-ip)
        if [ "$SOURCE" = "$LAST_SOURCE" ] && [ "$TARGET" = "$LAST_TARGET" ]; then 
            continue
        fi 
        if [ "$SOURCE" = "0.0.0.0" ] || [ "$TARGET" = "0.0.0.0" ]; then 
            continue
        fi 

        if [ -n "$LAST_SOURCE" ] && [ -n "$LAST_TARGET" ]; then
            # delete old mapping 
            if iptables-save -t nat | grep "-A POSTROUTING -p all -s $LAST_SOURCE/32 -j SNAT --to-source $LAST_TARGET"; then
                iptables -t nat -D POSTROUTING -p all -s "$LAST_SOURCE"/32 -j SNAT --to-source "$LAST_TARGET"
            fi
        fi

        # delete all existing snats for source IP
        for rule in $(iptables-save -t nat | grep -- "-A POSTROUTING -s $SOURCE/32 -j SNAT --to-source"); do 
            if ! printf "%s" "$rule" | grep -- "-A POSTROUTING -s $SOURCE/32 -j SNAT --to-source $TARGET"; then
                eval "iptables -t nat $(printf "%s" "$rule" | sed 's/-A/-D/g')"
            else 
                RULE_FOUND=true
            fi
        done
        if [ ! "$RULE_FOUND" = "true" ]; then
            iptables -t nat -I POSTROUTING -p all -s "$SOURCE" -j SNAT --to-source "$TARGET"
            printf "%s=%s" "$SOURCE" "$TARGET" > /mapped-ip
        fi
        LAST_SOURCE=$SOURCE
        LAST_TARGET=$TARGET
    fi 
done