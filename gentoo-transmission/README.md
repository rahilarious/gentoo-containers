### Transmission Daemon

Download or seed torrents remotely or locally with convenience of web ui with Transmission container which is optimized for your CPU.

#### Usage:
Works with rootless docker/podman as well.

Here are examples:

```
podman(/docker) run \
 --init \
-p 9091:9091 \
-p 51413:51413 \
-p 51413:51413/udp \
-v $(pwd)/downloads:/downloads \
-v $(pwd)/config:/config \
ghcr.io/rahilarious/gentoo-transmission:<microarch level>
```
Run transmission service with web-ui on port 9091

```
podman(/docker) run \
 --init \
-p 9091:9091 \
-p 51413:51413 \
-p 51413:51413/udp \
-v $(pwd)/downloads:/downloads \
-v $(pwd)/config:/config \
ghcr.io/rahilarious/gentoo-transmission:<microarch level> \
--log-level=error --peerlimit-global 666
```
Same as above but log only errors and increase global peer limit to 666. For more options transmission-daemon(1)

