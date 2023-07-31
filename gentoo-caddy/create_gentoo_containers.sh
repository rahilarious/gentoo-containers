#!/usr/bin/bash

## THIS SCRIPT SHOULD NOT BE "EXEC"UTED IN "main" BRANCH
## chmod +x this script & execute it like any other binary. DO NOT source IT.

# exit on errors
set -e

#### VARIABLES
CURRENT_DIR=$(realpath $(dirname $0))

PKG_NAME=$(basename ${CURRENT_DIR})

MICROARCH=$(cd ${CURRENT_DIR} && git branch --show-current)
LEVEL_MICROARCH=$(echo ${MICROARCH} | cut -d- -f3)

DIST_DIR=$(portageq distdir)
HOST_DIST_DIR=${DIST_DIR}

REPOS_DIR=$(dirname $(portageq get_repo_path / gentoo))
HOST_REPOS_DIR=${REPOS_DIR}

REGISTRY_WITH_USERNAME="ghcr.io/rahilarious"

BINPKGS_DIR=$(portageq envvar PKGDIR)
HOST_BINPKGS_DIR=

URI_BINHOST=

#### CODE

time sudo podman build \
     -f ${CURRENT_DIR}/Containerfile \
     -v ${HOST_REPOS_DIR}:${REPOS_DIR} \
     -v ${HOST_DIST_DIR}:${DIST_DIR} \
     -v ${HOST_BINPKGS_DIR}:${BINPKGS_DIR} \
     -t ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} \
     --build-arg MICROARCH_LEVEL="${LEVEL_MICROARCH}" \
     --build-arg=BINHOST_URI="${URI_BINHOST}" \



