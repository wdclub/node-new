#!/bin/sh

BASEDIR=$(dirname "$0")

INNER_UID=10000
target_uid=$(grep "dockremap" /etc/subuid)
target_uid=$(echo "$target_uid" | cut -d ":" -f 2)
INNER_UID=$(($target_uid + $INNER_UID))

DIRS=\
'{
    "writable": [
        "data/etho",
        "data/ethofs",
        ".icc"
    ]
}'

chmod +x "$BASEDIR/"*.sh
chmod +x "$BASEDIR/../geth"
echo "Configuring access permissions for UID: $INNER_UID"
for row in $(printf "%s\n" "$DIRS" | jq -r '.writable[]'); do
    echo "Setting permission for path: $BASEDIR/../$row"
    chown -R $INNER_UID:ans "$BASEDIR/../$row" && echo "Access permission to '$row' set to uid $INNER_UID."
done
exit $?
