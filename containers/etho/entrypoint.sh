#!/bin/sh
SOURCE_IP="$(hostname -I | awk '{$1=$1};1')"
if [ -n "$EXTERNAL_IP" ]; then
    touch /home/etho/waiting_for_external_ip
    while ! grep "$SOURCE_IP=$EXTERNAL_IP" /ip-map/mapped-ip; do
        if ! grep "$SOURCE_IP=$EXTERNAL_IP" /etho/map-ip; then 
            printf "%s=%s" "$SOURCE_IP" "$EXTERNAL_IP" > /etho/map-ip
            echo "Mapping configuration generated"
        else 
           echo "Waiting for snad configuration of EXTERNAL_IP" 
        fi
        sleep 5
    done 
    echo "SNAT configured. Starting node..." 
    rm /home/etho/waiting_for_external_ip
fi

/usr/sbin/geth-etho --nousb --syncmode=light --cache=512 --rpc --rpcaddr "0.0.0.0" --rpcvhosts="mn,localhost"
