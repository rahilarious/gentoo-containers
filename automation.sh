#!/usr/bin/bash

set -e

### variables
BUILD_TAG=$(date +%Y%m%d%H%M%S)
read -p "Enter Github API token: " GITHUB_API_TOKEN
read -p "Enter Docker API token: " DOCKER_API_TOKEN
MICROARCHITECTURES="x86-64-v2 x86-64-v3"
GIT_REPO_PATH="${HOME}/containers/gentoo"

cd ${GIT_REPO_PATH}
for microarch in ${MICROARCHITECTURES}
do
    git switch ${microarch}
    for PKG_DIR in $(ls -d ${GIT_REPO_PATH}/*/)
    do
	PKG=$(basename ${PKG_DIR})
	if [[ -f ${PKG_DIR}extra_tag ]]; then
	    read EXTRA_TAG < ${PKG_DIR}extra_tag
    	    echo "Extra tag: ${EXTRA_TAG}"
	fi

	echo $PKG_DIR
	echo "Package name: ${PKG}"
    done
done

git switch main
