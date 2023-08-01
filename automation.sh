#!/usr/bin/bash

# exit on errors
set -e

### variables
BUILD_TAG=$(date +%Y%m%d%H%M)
REGISTRIES_WITH_USERNAME="ghcr.io/rahilarious docker.io/rahilarious"
MAIN_REGISTRY_WITH_USERNAME="ghcr.io/rahilarious"
MICROARCHS="x86-64-v2 x86-64-v3"
CURRENT_DIR="$(realpath $(dirname $0))"
PKG_DIRS="$(ls -d ${CURRENT_DIR}/*/)"

### CODE
cd ${CURRENT_DIR}
for MICROARCH in ${MICROARCHS}
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
	    sudo podman save ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} | zstdmt -z > /tmp/${PKG_NAME}-${MICROARCH}-${BUILD_TAG}.tar.zst
	    ls -lah /tmp
	fi

	### TAG & PUSH IMAGE
	for REGISTRY_WITH_USERNAME in ${REGISTRIES_WITH_USERNAME}
	do
	    echo "##########       ${REGISTRY_WITH_USERNAME}         ############"

	    ### TAG & PUSH BASE TAG
	    if [[ ${REGISTRY_WITH_USERNAME} != ${MAIN_REGISTRY_WITH_USERNAME} ]]
	    then
		sudo podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}
	    fi
	    sudo podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}
	    
	    ### TAG & PUSH EXTRA TAG(s)
	    if [[ -s ${PKG_DIR}extra_tag ]]
	    then
		read EXTRA_TAG < ${PKG_DIR}extra_tag
		sudo podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}
		sudo podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}-${BUILD_TAG}

		sudo podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}
		sudo podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}-${BUILD_TAG}
	    else
		sudo podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${BUILD_TAG}

		sudo podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${BUILD_TAG}
	    fi
	done
    done
done

git switch main

echo "Congratulations !!! You can go for a break now."

