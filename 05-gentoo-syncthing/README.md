### Syncthing

Run syncthing with binary which is optimized for your CPU. This image is compatible with [official syncthing image](https://hub.docker.com/r/syncthing/syncthing) except `PUID` & `PGID` environmental variables. Use `docker/podman -u <uid>:<gid>` for that.

#### Usage:
Refer to official syncthing docker [documentation](https://github.com/syncthing/syncthing/blob/main/README-Docker.md)

Here are examples:

**[Recommended]** Run syncthing on host network where web GUI listens on localhost (127.0.0.1) 
```
podman(/docker) run \
--network=host \
-u testuser \
-v /whatever/syncthing:/var/syncthing \
-e STGUIADDRESS=127.0.0.1:8384
ghcr.io/rahilarious/gentoo-syncthing:<microarch-level>
```

Run syncthing on host network where web GUI listens on all interfaces (0.0.0.0)
```
podman(/docker) run \
--network=host \
-u testuser \
-v /whatever/syncthing:/var/syncthing \
ghcr.io/rahilarious/gentoo-syncthing:<microarch-level>
```

Run syncthing and expose needed ports while web GUI accessible only on localhost
```
podman(/docker) run \
-p 127.0.0.1:8384:8384/tcp -p 21027:21027/udp -p 22000:22000/tcp -p 22000:22000/udp \
-u testuser \
-v /whatever/syncthing:/var/syncthing \
ghcr.io/rahilarious/gentoo-syncthing:<microarch-level>
```


