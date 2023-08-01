### Coredns

Run coredns container which is optimized for your CPU. This image is compatible with [official coredns image](https://hub.docker.com/r/coredns/coredns).

#### Usage:
Works with rootless docker/podman as well.

Here are examples:

```
podman(/docker) run \
-p 53:53 -p 53:53/udp \
--init -u coredns \
-v /tmp/Corefile:/Corefile \
ghcr.io/rahilarious/gentoo-coredns:<microarch level> \
-conf /Corefile
```
Runs coredns on port 53 tcp & udp using config file /tmp/Corefile on host.

