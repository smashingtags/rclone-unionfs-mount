#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Copyright (c) 2019, PhysK
# All rights reserved.

# Logging Function
function log() {
    echo "[Uploader] ${1}"
}

downloadpath=/move
IFS=$'\n'

FILE=$1
GDSA=$2
log "[Upload] Upload started for $FILE using $GDSA"

STARTTIME=$(date +%s)
FILEBASE=$(basename "${FILE}")
FILEDIR=$(dirname "${FILE}" | sed "s#${downloadpath}/##g")

JSONFILE="/config/json/${FILEBASE}.json"
# BWLIMITFILE="/app/plex/bwlimit.plex"

# add to file lock to stop another process being spawned while file is moving
echo "lock" >"${FILE}.lck"

#get Human readable filesize
HRFILESIZE=$(stat -c %s "${FILE}" | numfmt --to=iec-i --suffix=B --padding=7)

REMOTE=$GDSA

log "[Upload] Uploading ${FILE} to ${REMOTE}"
LOGFILE="/config/logs/${FILEBASE}.log"
# if [ -f "${BWLIMITFILE}" ]; then
#     BWLIMITSPEED="$(cat ${BWLIMITFILE})"
#     BWLIMIT="--bwlimit=${BWLIMITSPEED}"
# else
#     BWLIMIT=""
# fi


#create and chmod the log file so that webui can read it
touch "${LOGFILE}"
chmod 777 "${LOGFILE}"

#update json file for Uploader GUI
echo "{\"filedir\": \"${FILEDIR}\",\"filebase\": \"${FILEBASE}\",\"filesize\": \"${HRFILESIZE}\",\"status\": \"uploading\",\"logfile\": \"${LOGFILE}\",\"gdsa\": \"${GDSA}\"}" >"${JSONFILE}"
log "[Upload] Starting Upload"
rclone moveto --tpslimit 6 --checkers=20 \
    --config /config/rclone-docker.conf \
    --log-file="${LOGFILE}" --log-level INFO --stats 2s \
    --drive-chunk-size=32M \
    "${FILE}" "${REMOTE}:${FILEDIR}/${FILEBASE}"

## add after drive chunk to re-enable bwlimit ${BWLIMIT}
ENDTIME=$(date +%s)
if [ "${RC_ENABLED}" == "true" ]; then
    sleep 10s
    rclone rc vfs/forget dir="${FILEDIR}" --user "${RC_USER:-user}" --pass "${RC_PASS:-xxx}" --no-output
fi
#update json file for Uploader GUI
echo "{\"filedir\": \"/${FILEDIR}\",\"filebase\": \"${FILEBASE}\",\"filesize\": \"${HRFILESIZE}\",\"status\": \"done\",\"gdsa\": \"${GDSA}\",\"starttime\": \"${STARTTIME}\",\"endtime\": \"${ENDTIME}\"}" >"${JSONFILE}"

log "[Upload] Upload complete for $FILE, Cleaning up"

#cleanup
#remove file lock
rm -f "${FILE}.lck"
rm -f "${LOGFILE}"
rm -f "/config/pid/${FILEBASE}.trans"
find "${downloadpath}" -mindepth 2 -type d -empty -delete
sleep 60
rm -f "${JSONFILE}"
