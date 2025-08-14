#!/bin/sh
DOWNLOADS_DIR=$1
SERVICE_URL=$2
TEST_FILE_NAME=.healthcheck.test
TEST_FILE_PATH=$DOWNLOADS_DIR/$TEST_FILE_NAME
QBITTORRENT_PROCESS_NAME="qbittorrent-nox"

if ! pgrep -x $QBITTORRENT_PROCESS_NAME >/dev/null 2>&1; then
  echo "qbittorrent-nox is not running"
  exit 1
fi

if ! wget --quiet --spider --no-check-certificate $SERVICE_URL >/dev/null 2>&1; then
  echo "Service is not accessible ($SERVICE_URL)"
  exit 1
fi

if ! stat $DOWNLOADS_DIR >/dev/null 2>&1; then
  echo "NFS mount point not available ($DOWNLOADS_DIR)"
  exit 1
fi

if ! touch $TEST_FILE_PATH >/dev/null 2>&1; then
  echo "Cannot write to NFS mount point ($TEST_FILE_PATH)"
  exit 1
fi

if ! rm $TEST_FILE_PATH >/dev/null 2>&1; then
  echo "Cannot remote test file ($TEST_FILE_PATH)"
  exit 1
fi

echo "Service is healthy!"
exit 0
