### [THELOUNGE] (https://thelounge.chat/)

Modern, responsive, cross-platform, self-hosted web IRC client.

This image is **fully compatible** with [official image](https://hub.docker.com/r/thelounge/thelounge/)

#### What differs from official image?
Image is based on Gentoo which offers numerous benefits. Checkout [this page](https://github.com/rahilarious/gentoo-containers/blob/main/README.md) for details.

#### Usage:

Example
```
podman(/docker) run --detach \
             --name thelounge \
             --publish 9000:9000 \
             --volume ~/.thelounge:/var/opt/thelounge \
             ghcr.io/rahilarious/gentoo-thelounge:<microarch-level>
```
For more examples, checkout [official documentation](https://github.com/thelounge/thelounge-docker/blob/master/README.md). Make sure to change image url when following official docs
