FROM alpine:latest

# setup dependencies
RUN apk update && apk upgrade
RUN apk add iptables

HEALTHCHECK --interval=5s CMD exit 0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["tail", "-f","/dev/null"]