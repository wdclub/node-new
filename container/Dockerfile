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

FROM ubuntu:bionic

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl unzip jq -y

HEALTHCHECK --interval=5s --timeout=3s --start-period=30s --retries=5 \
  CMD curl -X POST  --url http://localhost:8545 \
                                        --header 'Cache-Control: no-cache' \
                                        --header 'Content-Type: application/json' \
                                        --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' \
                                        --silent -k --fail || exit 1

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 10000 \
         etho

# copy necessary scripts
WORKDIR /home/etho/
COPY get-geth.sh ./get-geth.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-geth.sh ./get-node-info.sh ./get-version.sh

# get latest geth
RUN ./get-geth.sh
RUN mv ./geth /usr/sbin/geth-etho
RUN chmod +x /usr/sbin/geth-etho

# run etho masternode
USER etho
ENTRYPOINT [ "/usr/sbin/geth-etho", "--syncmode=fast", "--cache=512", "--rpc" ]