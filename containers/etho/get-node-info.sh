#!/bin/sh

ver=$(./get-version.sh)
type="ETHO_SN"

block_number=$(curl -sX POST --url http://localhost:8545 \
    --header 'Cache-Control: no-cache' \
    --header 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' | \
    jq .result.number -r)
block_count=$(printf "%d\n" $block_number)

RESULT=$(curl -sX POST --url http://localhost:8545     --header 'Cache-Control: no-cache'     --header 'Content-Type: application/json'     --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}')
syncing=$(printf "%s" "$RESULT" | jq .result -r)
sync_status=false
if [ "$syncing" = "false" ]; then
    sync_status=true
else 
    block_count=$(printf "%d" "$(printf "%s" "$RESULT" | jq .result.currentBlock -r)")
    sync_status=false
fi

RESULT=$(curl -sX POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' --header 'Cache-Control: no-cache' --header 'Content-Type: application/json' --url http://localhost:8545)
block_hash=$(printf "%s" "$RESULT" | jq .result.hash -r)

mn_status="not reported"
if [ "$sync_status" = "false" ]; then
    mn_status_level="error"
else 
    mn_status_level="ok"
fi

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
BLOCK_HASH: %s
MN STATUS: %s
MN STATUS LEVEL: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$block_hash" "$mn_status" "$mn_status_level" "$sync_status" > /home/etho/.ether1/node.info

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
BLOCK_HASH: %s
MN STATUS: %s
MN STATUS LEVEL: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$block_hash" "$mn_status" "$mn_status_level" "$sync_status"
