### Gentoo

This is the base image. All other images offered by this project are built from this image.

#### Usage:

Simple example:
```
podman(/docker) run -it --name testing-gentoo \
	--volume gentoo_repos:/var/db/repos \
	--volume gentoo_distfiles:/var/cache/distfiles \
	ghcr.io/rahilarious/gentoo:<microarch-level> bash
```
