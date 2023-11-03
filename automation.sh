#!/usr/bin/bash

# exit on errors
set -e

### variables
CURRENT_DIR="$(realpath $(dirname $0))"
PKG_DIRS="$(ls -d ${CURRENT_DIR}/*gentoo*/)"

source ${CURRENT_DIR}/config.env


### CODE
cd ${CURRENT_DIR}
for MICROARCH in ${MICROARCHS[@]}
do
    git switch ${MICROARCH}
    for PKG_DIR in ${PKG_DIRS}
    do
	PKG_NAME=$(basename ${PKG_DIR} | cut -d- -f1 --complement)

	## BUILD IMAGE
	echo "##########       ${PKG_NAME} (${MICROARCH})         ############"
	if [[ -s ${PKG_DIR}create_gentoo_containers.sh ]]
	then
	    ${PKG_DIR}create_gentoo_containers.sh
	else
	    echo "ERROR: can't find build script. Exiting..."
	    exit 1
	fi
	
	### SAVE gentoo IMAGES in tar.zst to /tmp for release
	if [[ ${PKG_NAME} == "gentoo" ]]
	then
	    echo "##########      Saving gentoo:${MICROARCH} image in /tmp         ############"
	    doas podman save ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} | zstdmt -z > /tmp/${PKG_NAME}-${MICROARCH}-${BUILD_TAG}.tar.zst
	    ls -lah /tmp
	fi
    done
done

git switch main
git tag -m "${BUILD_TAG}" ${BUILD_TAG} main
git push ${BUILD_TAG}

echo "Congratulations !!! You may upload tar files and release."

