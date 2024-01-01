### Blocky

Block ads network-wide using DNS proxy (server), [Blocky](https://github.com/0xERR0R/blocky/) which supports DNS-over-https (DoH), DNS-over-TLS (DoT). Alternative to AdGuard Home and Pi-Hole written in Go. Gentoo variant is optimized for your CPU.

This image is compatible with official Blocky image at https://hub.docker.com/r/spx01/blocky

#### Usage:

```
podman(/docker) run --rm \
-v /path/to/blocky/config.yml:/app/config.yml \
-p 4000:4000 -p 53:53/udp \
ghcr.io/rahilarious/gentoo-blocky:<microarch-level>
```
