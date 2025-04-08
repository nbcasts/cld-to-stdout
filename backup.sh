#!/usr/bin/env bash

# Function to log messages to stderr
log() {
  echo "$@" >&2
}

if [ -z "$CLOUDINARY_API_KEY" ]; then
  log "ERROR: CLOUDINARY_API_KEY is not set. Set this environment variable and try again."
  exit 1
fi

if [ -z "$CLOUDINARY_API_SECRET" ]; then
  log "ERROR: CLOUDINARY_API_SECRET is not set. Set this environment variable and try again."
exit 1
fi

if [ -z "$CLOUDINARY_CLOUD_NAME" ]; then
  log "ERROR: CLOUDINARY_CLOUD_NAME is not set. Set this environment variable and try again."
  exit 1
fi

export CLOUDINARY_URL=cloudinary://${CLOUDINARY_API_KEY}:${CLOUDINARY_API_SECRET}@${CLOUDINARY_CLOUD_NAME}

BACKUP_DIR=/tmp/cloudinary_download

# Pull cloudinary contents to local dir
cld sync --pull $BACKUP_DIR / 2>&2
if [ $? -ne 0 ]; then
  log "ERROR: Failed to sync Cloudinary contents"
  exit 1
fi

# set -e

tar czf - $BACKUP_DIR
