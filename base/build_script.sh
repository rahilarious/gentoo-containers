#!/usr/bin/bash

set -e

echo '#####        Configuring make.conf      ######'
cp -v /etc/portage/make.conf /etc/portage/original-make.conf
sed -i "s|-O2|-march=x86-64-${MICROARCH_LEVEL} -O2|g" /etc/portage/make.conf
cat <<-EOF | tee -a /etc/portage/make.conf
	GOAMD64=${MICROARCH_LEVEL}
	RUSTFLAGS='-C target-cpu=x86-64-${MICROARCH_LEVEL} -C strip=symbols -C opt-level=2'
	FEATURES='${PORTAGE_FEATURES}'
	ACCEPT_KEYWORDS="~\${ARCH}"
	GENTOO_MIRRORS='${LOCAL_MIRROR} http://distfiles.gentoo.org'
	CPU_FLAGS_X86='${PORTAGE_CPU_FLAGS}'
	USE='lto jit -iptables nftables pgo -smartcard tofu graphite'
	CLEAN_DELAY="3"
	MAKEOPTS="-j$(nproc --ignore=${SUBSTRACT_NO_OF_CPU_BY}) -l$(nproc)"
EOF

rm -v  /etc/portage/binrepos.conf/*.conf
if [ -n "${BINHOST_URI}" ]; then
    echo '#####        Configuring binrepos.conf      ######'
    cat <<-EOF | tee -a /etc/portage/binrepos.conf/gentoo-on-steroids.conf
	[gentoo-on-steroids-binpkgserver]
	priority=100
	sync-uri=${BINHOST_URI}
	EOF
fi
echo '#####        Configuring locale.gen in case glibc needs update      ######'
cat <<-EOF | tee -a /etc/locale.gen
	en_IN UTF-8
	en_US.UTF-8 UTF-8
	en_US ISO-8859-1
EOF

echo '#####        Configuring /etc/portage/gnupg      ######'
getuto -v
#gpg --homedir=/etc/portage/gnupg -v --locate-keys me@rahil.rocks
#echo -e '5\ny\n' | gpg --homedir=/etc/portage/gnupg --command-fd=0 --edit-key me@rahil.rocks trust

if [ -d /var/db/repos/gentoo/.git ]; then
    echo "#####    Found git Gentoo repo     #####"
    emerge -vgkbn1 --quiet-build dev-vcs/git
    cat <<-EOF | tee -a /etc/portage/repos.conf
	[gentoo]
	location = /var/db/repos/gentoo
	sync-type = git
	sync-uri = https://github.com/gentoo-mirror/gentoo.git
	clone-depth = 1
	sync-depth = 1
	autosync = yes
	EOF
fi

echo '######       Syncing gentoo repo       #######'
emerge --sync

if [ -f /etc/portage/repos.conf ]; then
    echo '#####        Removing repos.conf      #####'
    rm -v /etc/portage/repos.conf
fi

echo '#####        setting profile      ######'
eselect profile set default/linux/amd64/23.0/no-multilib/hardened/systemd
eselect profile list

echo '#######      Update portage & toolchain if necessary       ######'
emerge -v --quiet-build -gkb1u sys-apps/portage
emerge -vgkbu1 --quiet-build sys-libs/glibc sys-devel/gcc sys-devel/binutils sys-kernel/linux-headers -X 'gcc:15'
emerge -c sys-devel/binutils sys-devel/gcc

emerge -vgkbn1 --quiet-build sys-devel/distcc
echo '######         Enabling distcc        ########'
echo 'FEATURES="${FEATURES} distcc"' | tee -a /etc/portage/make.conf
source /etc/profile
export PATH="/usr/lib/distcc/bin:${PATH}"
echo "#########     New PATH env : ${PATH}     ######"
distcc-config --set-hosts "${DISTCC_SERVERS}"
echo '########    Distcc servers :      #######'
distcc-config --get-hosts

emerge -vgkbn1 --quiet-build dev-vcs/git app-admin/ansible-core app-admin/doas
echo 'permit nopass root' | tee -a /etc/doas.conf

mkdir -v /tmp/ansible-homelab
git clone "${ANSIBLE_REPO}" /tmp/ansible-homelab
echo '############         Installing ansible requirements            #########'
cd /tmp/ansible-homelab
ansible-galaxy install -r requirements.yml
echo '############         Dirty trick to force it as container            #########'
sed -i -e '/virtualization_type/d' /tmp/ansible-homelab/playbooks/set_facts.yml

cat <<-EOF | tee -a /tmp/ansible-homelab/host_vars/currenthost.yml
	base_packages:
	  - app-portage/gentoolkit
	  - app-editors/mg
	  - app-editors/nano
	  - app-eselect/eselect-repository
	  - app-misc/jq
	  - app-misc/tmux
	  - app-portage/cpuid2cpuflags
	  - app-shells/bash-completion
	  - app-text/tree
	  - dev-vcs/git
	  - sys-apps/lsb-release
	  - sys-devel/distcc
	  - sys-process/htop
	  - sys-process/lsof
	portage_features:
	  - '${PORTAGE_FEATURES}'
	portage_local_mirror: '${LOCAL_MIRROR}'
	portage_march: x86-64-${MICROARCH_LEVEL}
	portage_goamd64: ${MICROARCH_LEVEL}
	portage_cpu_flags: '${PORTAGE_CPU_FLAGS}'
	gentoo_binpkg_server_uri: '${BINHOST_URI}'
EOF
ansible-playbook -l currenthost local.yml

mv -v /etc/portage/default-make.conf /etc/portage/builder-make.conf
mv -v /etc/portage/original-make.conf /etc/portage/default-make.conf
if [ ! -d /var/db/repos/gentoo/.git ]; then
    echo '#####        Found rsynced Gentoo repo      #####'
    echo '####       Switching to git Gentoo repo      #####'
    rm -rf /var/db/repos/gentoo
    emerge --sync
fi

echo '############         Cleanup orphan packages            #########'
emerge -vuNDgkb --quiet-build --with-bdeps=y @world
emerge -c

echo '############         Rebuilding whole stage3            #########'
emerge -vgkb --quiet-build --with-bdeps=y -e @world -X ''

echo '############         Post installation configurations            #########'

echo '############         setting nano as default editor            #########'
eselect editor set mg

echo '############         Cleaning up            #########'

emerge -c
distcc-config --set-hosts "localhost"
sed -i -e "s|${LOCAL_MIRROR}||g" /etc/portage/make.conf/mirrors
rm -rf /root/.ansible /tmp/ansible* /var/tmp/portage
rm /var/log/emerge.log /var/log/portage/elog/summary.log
truncate -s0 /var/log/emerge* /etc/portage/binrepos.conf/gentoo-on-steroids.conf

echo '###########       CONGRATULATIONS !!! EVERYTHING SUCCESSFUL      #######'
