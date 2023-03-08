#!/bin/bash

#podman run -it --secret gpg-sign-priv.key --mount type=tmpfs,tmpfs-size=4G,dst=/var/tmp --mount type=tmpfs,tmpfs-size=4G,dst=/tmp -v gentoo_repo:/var/db/repos/gentoo -v gentoo_distfiles:/var/cache/distfiles -v gentoo_binpkgs:/var/cache/binpkgs  -v /root/.gnupg rahilarious/gentoo /bin/bash


time { cd ${HOME}/containers/gentoo/gentoo-base && \
    wget -c https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/$(curl -sL https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt | tail -n1 | awk '{print $1;}') && \
    podman import -c 'CMD ["/usr/bin/bash"]' $(find ${HOME}/containers/gentoo/gentoo-base -type f -name 'stage3*' 2> /dev/null | tail -n1) gentoo/stage3:nomultilib-systemd-merged && \
    podman build --squash-all \
	   -f ${HOME}/containers/gentoo/gentoo-base/Containerfile \
	   -v ${HOME}/.local/share/containers/storage/volumes/gentoo_repo/_data:/var/db/repos/gentoo \
	   -v ${HOME}/.local/share/containers/storage/volumes/gentoo_distfiles/_data:/var/cache/distfiles \
	   -v ${HOME}/.local/share/containers/storage/volumes/gentoo_binpkgs/_data:/var/cache/binpkgs \
	   --secret=id=ansible-homelab-vaultpass,src=${HOME}/containers/gentoo/gentoo-base/vaultpass ; }

# podman run -it \
#        --mount type=tmpfs,tmpfs-size=4G,dst=/var/tmp \
#        --mount type=tmpfs,tmpfs-size=4G,dst=/tmp \
#        -v gentoo_repo:/var/db/repos/gentoo \
#        -v gentoo_distfiles:/var/cache/distfiles \
#        -v gentoo_binpkgs:/var/cache/binpkgs  \
#        -v gpg_priv_sign:/root/.gnupg \
#        -v /var/log \
#        --secret ansible-homelab-vaultpass
#        docker.io/gentoo/stage3:nomultilib-systemd-merged


# # copy gpg.sh then run it


# # TODO replace it with ansible
# FEATURES='-pid-sandbox -network-sandbox -ipc-sandbox binpkg-ignore-signature' ACCEPT_KEYWORDS='~amd64' emerge -vbgk --quiet-build --with-bdeps=y app-editors/mg && emerge -C app-editors/nano && eselect editor set mg


# FEATURES='-pid-sandbox -network-sandbox -ipc-sandbox binpkg-ignore-signature' ACCEPT_KEYWORDS='~amd64' CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3" USE='lto jit -iptables nftables pgo -smartcard tofu graphite' emerge -vbgk --quiet-build --with-bdeps=y dev-vcs/git

# FEATURES='-pid-sandbox -network-sandbox -ipc-sandbox binpkg-ignore-signature' ACCEPT_KEYWORDS='~amd64' CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3" USE='lto jit -iptables nftables pgo -smartcard tofu graphite' emerge -vbgk --quiet-build --with-bdeps=n -1 app-admin/ansible-core

# mkdir /tmp/ansible-homelab && git clone https://gitlab.com/rahilarious/ansible-homelab.git /tmp/ansible-homelab
# cat /run/secrets/ansible-homelab-vaultpass > /tmp/ansible-homelab/.vaultpass
# cd /tmp/ansible-homelab && ansible-galaxy install -r requirements.yml
# cat <<EOF > /tmp/ansible-homelab/host_vars/currenthost.yml
# portage_makeconf_extra: |
#   BINPKG_GPG_SIGNING_GPG_HOME="/root/.gnupg"
#   BINPKG_GPG_SIGNING_KEY="0x6D39AB4713797E6F"
# portage_features:
#   - -ipc-sandbox
#   - -network-sandbox
#   - -pid-sandbox
#   - binpkg-ignore-signature
# EOF
# ansible-playbook -l currenthost local.yml


# emerge -avgkb --quiet-build --with-bdeps=y -e -X 'acct-user/* acct-group/* virtual/* sys-kernel/* sys-firmware/* *-bin' @world

# emerge -ca ansible-core
# # FEATURES='-pid-sandbox -network-sandbox -ipc-sandbox' ACCEPT_KEYWORDS='~amd64' CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3" USE='lto jit -iptables nftables pgo -smartcard tofu graphite' emerge -vbgkuND --quiet-build --with-bdeps=y @world



