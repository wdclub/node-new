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

ver=$(./get-version.sh)
type="ETHO_SN"

block_number=$(curl -sX POST --url http://localhost:8545 \
    --header 'Cache-Control: no-cache' \
    --header 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":["latest", false],"id":1}' | \
    jq .result -r)
block_count=$(printf "%d\n" $block_number)

syncing=$(curl -sX POST --url http://localhost:8545 \
    --header 'Cache-Control: no-cache' \
    --header 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_syncing","params":["latest", false],"id":1}' | \
    jq .result -r)
sync_status=false
if [ "$syncing" = "false" ]; then
    sync_status=true
fi

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$sync_status" > /home/etho/.ether1/node.info

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$sync_status"