#!/bin/sh

if [ -f "/home/etho/waiting_for_external_ip" ]; then
    exit 0
fi

if ! /usr/sbin/geth-etho --exec "admin.nodeInfo.enode" attach ipc://./home/etho/.ether1/geth.ipc; then
    exit 0
fi

RESULT=$(curl -s -X POST -w "\n%{http_code}\n" --url http://localhost:8545 \
                                        --header 'Cache-Control: no-cache' \
                                        --header 'Content-Type: application/json' \
                                        --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' \
                                        --silent -k)

HTTP_CODE=$(printf "%s" "$RESULT" | tail -n 1) 
if [ "$HTTP_CODE" = "200" ]; then exit 0; fi

exit 1
