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
RUN apt-get install wget curl runit unzip jq -y

ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh
HEALTHCHECK --interval=30s --timeout=60s --start-period=30s --retries=3 \
  CMD /healthcheck.sh

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 10000 \
         etho

# copy necessary scripts
# copy necessary scripts
WORKDIR /home/etho
COPY ./service ./service
RUN ln -s /home/etho/service /service
RUN chown -R etho:etho ./service
RUN chown -R etho:etho /service
RUN chmod +x ./service/ethofs/run ./service/ipfs/run
COPY ./boot.sh /sbin/boot.sh
COPY get-ethofs.sh ./get-ethofs.sh
COPY get-ipfs.sh ./get-ipfs.sh
COPY init-ipfs.sh ./init-ipfs.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-ethofs.sh ./get-ipfs.sh /sbin/boot.sh ./init-ipfs.sh /sbin/boot.sh

# get latest ethofs
RUN ./get-ethofs.sh

# get latest ipfs
RUN ./get-ipfs.sh

# run etho masternode
USER etho
CMD [ "/sbin/boot.sh" ]