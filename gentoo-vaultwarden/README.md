### Vaultwarden

Server and web client for Bitwarden compatible password manager, [Vaultwarden](https://github.com/dani-garcia/vaultwarden) which is written in Rust.

This image adds optimizations for your CPU's microarchitecture thus performance improvements and **fully compatible** with [official image](https://hub.docker.com/r/vaultwarden/server)

#### Usage:

Simplest example:
```
podman(/docker) run --name vaultwarden -v /vw-data/:/data/  -p 80:80 ghcr.io/rahilarious/gentoo-vaultwarden:<microarch-level>
```

For advanced setup check out project's [documentation](https://github.com/dani-garcia/vaultwarden)
