## Gentoo for GenZ
This is based on official Gentoo stage3 of [amd64-nomultilib-systemd-mergedusr](https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt)

#### Features
* Keyword updated to ~amd64
* Ready-made directory structure for /etc/portage
* Optimized for x86-64-v2  and x86-64-v3 [microarchitectures](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels)
* Globally compiled with ```lto, pgo, graphite``` USE flags
* Recompiled whole stage3 from scratch so that every package is optimized.
* Essential utilities added (htop, tmux, bash-completion..etc)

#### Usage
* Mandatory flags: `--mount type=tmpfs,tmpfs-size=75%,destination=/tmp --mount type=tmpfs,tmpfs-size=75%,destination=/var/tmp`
* Optional but recommended flags: `--volume gentoo_repos:/var/db/repos --volume gentoo_distfiles:/var/cache/distfiles --volume gentoo_binpkgs:/var/cache/binpkgs`
* Which image tag to use depends on microarchitecture level of CPU. Run this command to know. `/lib*/ld-linux-x86-64.so* --help | grep -i supported`, if that doesn't work for some reason, use `curl -sL https://raw.githubusercontent.com/HenrikBengtsson/x86-64-level/develop/x86-64-level | bash -s - --verbose`

