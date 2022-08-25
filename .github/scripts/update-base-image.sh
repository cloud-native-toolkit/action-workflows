#!/usr/bin/env base

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
REPO_DIR=$(cd ${SCRIPT_DIR}/../..; pwd -P)

NEW_VERSION="$1"

ls | grep -E "Dockerfile.*|Containerfile.*" | while read file; do
  if [[ -L "${file}" ]]; then
    continue
  fi

  CURRENT_VERSION=$(cat "${file}" | grep -E "^FROM" | sed -E "s/.*-(v[0-9]+[.][0-9]+[.][0-9]+)-.*/\1/g")

  cat "${file}" | sed -E "s/(FROM.*)${CURRENT_VERSION}(.*)/\1${NEW_VERSION}\2/g" > "${file}.bak"
  cp "${file}.bak" "${file}"
  rm "${file}.bak"
done
