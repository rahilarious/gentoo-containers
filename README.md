## Gentoo on steroids
Based on official Gentoo stage3 of [amd64-nomultilib-systemd-mergedusr](https://bouncer.gentoo.org/fetch/root/all/releases/amd64//autobuilds/latest-stage3-amd64-nomultilib-systemd-mergedusr.txt) plus hardened profile.

#### Features:
* All binaries are **optimized** for your CPU [microarchitecture](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels). Currently x86-64-v2 and x86-64-v3 are supported.
* Globally compiled with ```lto, pgo, graphite``` USE flags for utmost **performance**.
* Added essential **utilities** (i.e. tree, git, jq, htop, tmux, bash-completion..etc) in base image. Here is [full list](https://github.com/rahilarious/gentoo-containers/blob/main/base/Containerfile) of added packages.
* Keyword updated to ~amd64 offering **latest**, greatest and stable packages from Gentoo repos.
* Automated deployment and testing methods resuting in faster image **updates**
* All images are **tagged** with semantic versioning and base image's version (i.e. 2024.02.20)
* Most images are **compatible** with official images of that project (e.g. gento-redis)
* Save **storage** and **bandwidth** by less frequent base image updates (changes on toolchain upgrades which is like >3 months)
* Recompiled whole official stage3 with `--emptytree` to make sure every package is optimized.
* Well organized skeleton (boiler-plate) directory structure for /etc/portage

#### FAQs:
1. How do I know which [microarchitecture](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) my CPU has?
* Running `/lib*/ld-linux-x86-64.so* --help | grep -i supported` will show all supported microarchs by your CPU. If that doesn't work try `curl -sL https://raw.githubusercontent.com/HenrikBengtsson/x86-64-level/develop/x86-64-level | bash -s - --verbose`

