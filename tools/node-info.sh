#!/bin/sh

BASEDIR=$(dirname "$0")

if [ -f "$BASEDIR/../project_id" ]; then
    PROJECT=$(sed 's/PROJECT=//g' "$BASEDIR/../project_id")
    #PROJECT="--project-name $PROJECT"
else
    frffl=""
fi

if [ ! -f "$BASEDIR/../docker-compose.override.yml" ]; then
    mdwcf=""
fi

container=$(for c in $(docker-compose -f "$BASEDIR/../docker-compose.yml" ${mdwcf-"-f"} ${mdwcf-"$OVERRIDE_COMPOSE_FILE"} ${frffl-"--project-name"} ${frffl-"$PROJECT"} ps -q mn 2>/dev/null); do
    if [ "$(docker inspect -f '{{.State.Running}}' "$c" 2>/dev/null)" = "true" ]; then
        printf "%s" "$c"
        break
    fi
done)

STATUS="NOT RUNNING"
CREATED_AT="-"

if [ -z "$container" ]; then 
    printf "\
CREATED AT: %s
STATUS: %s" "$CREATED_AT" "$STATUS"
    exit
fi

docker exec "$container" /home/etho/get-node-info.sh
CONTAINER_INFO=$(docker ps --filter "id=$container" --format "{{.CreatedAt}}\t{{.Status}}" --no-trunc 2> /dev/null)
CREATED_AT=$(printf "%s" "$CONTAINER_INFO" | awk -F "\t" '{print $1}')
STATUS=$(printf "%s" "$CONTAINER_INFO" | awk -F "\t" '{print $2}')

if [ -z "$STATUS" ]; then
    STATUS="NOT RUNNING"
fi
if [ -z "$CREATED_AT" ]; then
    CREATED_AT="-"
fi

printf "\
CREATED AT: %s
STATUS: %s" "$CREATED_AT" "$STATUS"
