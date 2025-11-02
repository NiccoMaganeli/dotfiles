#!/bin/bash

VERBOSE=false

while getopts "v" opt; do
  case $opt in
  v)
    VERBOSE=true
    ;;
  \?)
    echo "Usage: $0 [-v]"
    exit 1
    ;;
  esac
done

log() {
  if [ "${VERBOSE}" = true ]; then
    echo "$@"
  fi
}

CURRENT_FOLDER=$(pwd)
CONFIG_PATH=$(realpath "${XDG_CONFIG_PATH:-${HOME}/.config}")

mkdir -p "${CONFIG_PATH}"

for dir in */; do
  [ -d "${dir}" ] || continue

  SANITIZED_DIR="${dir%/}"

  case "${SANITIZED_DIR}" in
  *\.*)
    log "Skipping directory with dot: ${SANITIZED_DIR}"
    continue
    ;;
  esac

  TARGET_DIR="${CONFIG_PATH}/${SANITIZED_DIR}"
  BACKUP_DIR="${TARGET_DIR}.old"
  SOURCE_DIR="${CURRENT_FOLDER}/${SANITIZED_DIR}"

  log "Processing:"
  log "${SOURCE_DIR}"
  log "${TARGET_DIR}"
  log "${BACKUP_DIR}"
  log "----------"

  if [ -L "${TARGET_DIR}" ]; then
    log "Deleting old symlink: ${TARGET_DIR}"
    rm "${TARGET_DIR}"
  elif [ -e "${TARGET_DIR}" ]; then
    log "Backing up existing: ${TARGET_DIR}"
    mv "${TARGET_DIR}" "${BACKUP_DIR}" 2>/dev/null
  fi

  ls aerospace

  log "Creating symlink: ${SOURCE_DIR} -> ${TARGET_DIR}"
  ln -sf "${SOURCE_DIR}" "${TARGET_DIR}"

  ls aerospace
done
