#!/usr/bin/bash

## THIS SCRIPT SHOULD NOT BE "EXEC"UTED IN "main" BRANCH
## chmod +x this script & execute it like any other binary. DO NOT source IT.

# exit on errors
set -e

#### VARIABLES
CURRENT_DIR=$(realpath $(dirname $0))
PARENT_DIR=$(dirname ${CURRENT_DIR})
source ${PARENT_DIR}/config.env
source ${CURRENT_DIR}/config.env
PKG_NAME=$(basename ${CURRENT_DIR} | cut -d- -f1 --complement)
MICROARCH=$(cd ${CURRENT_DIR} && git branch --show-current)
LEVEL_MICROARCH=$(echo ${MICROARCH} | cut -d- -f3)

#### CODE
source "${PARENT_DIR}"/scripts/modules/build-images.sh
source "${PARENT_DIR}"/scripts/modules/tag-images.sh
source "${PARENT_DIR}"/scripts/modules/push-images.sh
