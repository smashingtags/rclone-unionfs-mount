#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Copyright (c) 2019, PhysK
# All rights reserved.

# shellcheck disable=SC2086

UFS_PATH=$(cat /tmp/ufs.path)
mount_command="/usr/bin/mergerfs -o sync_read,auto_cache,dropcacheonclose=true,use_ino,allow_other,func.getattr=newest,category.create=ff,minfreespace=0,fsname=mergerfs ${UFS_PATH} /unionfs"

$mount_command
MERGERFS_PID=$(pgrep mergerfs)
echo "PID: ${MERGERFS_PID}"

while true; do

  if [ -z "${MERGERFS_PID}" ] || [ ! -e /proc/${MERGERFS_PID} ]; then
    $mount_command
    MERGERFS_PID=$(pgrep mergerfs)
  fi
  sleep 10s
done
