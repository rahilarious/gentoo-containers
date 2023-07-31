#!/usr/bin/bash

## THIS SCRIPT SHOULD NOT BE "EXEC"UTED IN "main" BRANCH
## chmod +x this script & execute it like any other binary. DO NOT source IT.

# exit on errors
set -e

#### VARIABLES
CURRENT_DIR=$(dirname $0)

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

CPU_FLAGS=

URI_BINHOST=

#### CODE

cd ${CURRENT_DIR}
wget -c https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/$(curl -sL https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt | tail -n1 | awk '{print $1;}')
time sudo podman import -c 'CMD ["/usr/bin/bash"]' $(find -type f -name 'stage3*xz' 2> /dev/null | tail -n1) gentoo/stage3:nomultilib-systemd-merged
echo "Initiating build in 5:"
sleep 1
echo "5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
time sudo podman build --squash-all \
     -f ${CURRENT_DIR}/Containerfile \
     -v ${HOST_REPOS_DIR}:${REPOS_DIR} \
     -v ${HOST_DIST_DIR}:${DIST_DIR} \
     -v ${HOST_BINPKGS_DIR}:${BINPKGS_DIR} \
     -t ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} \
     --build-arg MICROARCH_LEVEL="${LEVEL_MICROARCH}" \
     --build-arg=LOCAL_MIRROR="http://alienware.hl.rahil.website/" \
     --build-arg=ANSIBLE_REPO="https://gitlab.com/rahilarious/ansible-homelab.git" \
     --build-arg=DISTCC_SERVERS="localhost" \
     --build-arg=PORTAGE_CPU_FLAGS="${CPU_FLAGS}" \
     --build-arg=BINHOST_URI="${URI_BINHOST}" \

