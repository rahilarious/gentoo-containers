## Gentoo for GenZ
This is based on official Gentoo stage3 of [amd64-nomultilib-systemd-mergedusr](https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt)

#### Features
* Keyword updated to ~amd64
* Ready-made directory structure for /etc/portage
* Optimized for x86-64-v2  and x86-64-v3 [microarchitectures](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels)
* Globally compiled with ```lto, pgo, graphite``` USE flags
* Recompiled whole stage3 from scratch so that every package is optimized.
* Essential utilities added (htop, tmux, bash-completion..etc)
