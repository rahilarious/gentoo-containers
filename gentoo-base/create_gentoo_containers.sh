#!/bin/bash

time { cd ${HOME}/containers/gentoo/gentoo-base && \
    wget -c https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/$(curl -sL https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt | tail -n1 | awk '{print $1;}') && \
    sudo podman import -c 'CMD ["/usr/bin/bash"]' $(find ${HOME}/containers/gentoo/gentoo-base -type f -name 'stage3*xz' 2> /dev/null | tail -n1) gentoo/stage3:nomultilib-systemd-merged && \
    sudo podman build --squash-all \
	   -f ${HOME}/containers/gentoo/gentoo-base/Containerfile \
	   -v /var/db/repos:/var/db/repos \
	   -v /var/cache/distfiles:/var/cache/distfiles \
	   -t ghcr.io/rahilarious/gentoo:$(git branch --show-current) \
	   --secret=id=ansible-homelab-vaultpass,src=${HOME}/containers/gentoo/gentoo-base/vaultpass \
	   --build-arg=LOCAL_MIRROR="http://alienware.hl.rahil.website/" \
	   --build-arg=ANSIBLE_REPO="https://gitlab.com/rahilarious/ansible-homelab.git" \
	   --build-arg=DISTCC_SERVERS="localhost" \
       ; }
