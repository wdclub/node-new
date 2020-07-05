FROM debian:9-slim

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl unzip jq -y

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
WORKDIR /home/etho/
COPY entrypoint.sh /entrypoint.sh
COPY get-node.sh ./get-node.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-node.sh ./get-node-info.sh ./get-version.sh /entrypoint.sh

# get latest geth
RUN ./get-node.sh
RUN mv ./geth /usr/sbin/geth-etho
RUN chmod +x /usr/sbin/geth-etho

# run etho masternode
USER etho
ENTRYPOINT [ "/entrypoint.sh" ]
