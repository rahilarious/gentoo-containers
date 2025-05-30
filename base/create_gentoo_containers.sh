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
PKG_NAME="gentoo"
MICROARCH=$(cd ${CURRENT_DIR} && git branch --show-current)
LEVEL_MICROARCH=$(echo ${MICROARCH} | cut -d- -f3)

#### FUNCTIONS
wait_for_5() {
    echo "Initiating ${1} in 5:"
    sleep 1
    for i in {5..1}; do
	echo "${i}..."
	sleep 1
    done
}

#### CODE
cd ${CURRENT_DIR}

STAGE3_LATEST_BUILD_ID=$(curl -sL https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd.txt | gpg -d 2>/dev/null | tail -n1 | awk -F\/ '{print $1;}')
wget -c https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/"${STAGE3_LATEST_BUILD_ID}"/stage3-amd64-nomultilib-systemd-"${STAGE3_LATEST_BUILD_ID}".tar.xz{,.asc}
gpg --verify stage3-amd64-nomultilib-systemd-"${STAGE3_LATEST_BUILD_ID}".tar.xz.asc
[[ -f stage3-amd64-nomultilib-systemd-"${STAGE3_LATEST_BUILD_ID}".tar ]] ||  xzdec $(find -type f -name 'stage3*xz' 2> /dev/null | tail -n1) > stage3-amd64-nomultilib-systemd-"${STAGE3_LATEST_BUILD_ID}".tar
wait_for_5 import

time doas podman import -c 'CMD ["/usr/bin/bash"]' stage3-amd64-nomultilib-systemd-"${STAGE3_LATEST_BUILD_ID}".tar gentoo/stage3:nomultilib-systemd
wait_for_5 build
time doas podman build --squash-all \
     -f ${CURRENT_DIR}/Containerfile \
     -v ${HOST_GENTOO_REPO_DIR}:/var/db/repos/gentoo \
     -v ${HOST_GURU_REPO_DIR}:/var/db/repos/guru \
     -v ${HOST_DIST_DIR}:/var/cache/distfiles \
     -v ${HOST_BINPKGS_DIR}:/var/cache/binpkgs \
     -t ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} \
     --build-arg MICROARCH_LEVEL="${LEVEL_MICROARCH}" \
     --build-arg=LOCAL_MIRROR="${LOCAL_MIRROR}" \
     --build-arg=ANSIBLE_REPO="${ANSIBLE_REPO}" \
     --build-arg=DISTCC_SERVERS="${DISTCC_SERVERS}" \
     --build-arg=PORTAGE_CPU_FLAGS="${CPU_FLAGS}" \
     --build-arg=BINHOST_URI="${URI_BINHOST}" \


source "${PARENT_DIR}"/.scripts/modules/tag-images.sh
source "${PARENT_DIR}"/.scripts/modules/push-images.sh
