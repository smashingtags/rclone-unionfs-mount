#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Copyright (c) 2019, PhysK
# All rights reserved.

echo "--- VARS ---"
if [ -f /etc/services.d/uploader-gdrive/down ]; then
  echo "-> Running in tdrive mode";
fi

if [ -f /etc/services.d/uploader-tdrive/down ]; then
  echo "-> Running in gdrive mode";
fi

if grep -q GDSA01C /config/rclone-docker.conf && grep -q GDSA02C /config/rclone-docker.conf; then
  echo "-> Running in encrypted mode"
else
  echo "-> Not running in encrypted mode"
fi

# shellcheck disable=SC2012
ls -la /config/vars | awk '{print $9}'

echo "--- rclone ---"
echo "-> rclone version: $(rclone version)"
echo "-> Number of rclone instances running: $(pgrep rclone | wc -l)"
echo "-> Number of files being uploaded: $(pgrep -f moveto | wc -l)"

echo "--- transfers ---"
echo "Found $(find /move -type f -iname '*.lck' | wc -l) lock files under /move"
echo "Found $(find /config/pid -type f -iname '*.trans' | wc -l) transfer PID files under /config/pid"
echo "Found $(find /config/json -type f -iname '*.json' | wc -l) transfer JSON files unde /config/json"

echo "--- files ---"
echo "Found $(find /move -type f | wc -l) files waiting to be uploaded"
echo "Found $(find /move -maxdepth 1 -type d | wc -l) folders Under /move of which $(find /move -maxdepth 1 -type d -empty | wc -l) are empty"
