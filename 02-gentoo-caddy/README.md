### Caddy Server

Run Caddy container which is optimized for your CPU. This image is compatible with [official caddy image](https://hub.docker.com/_/caddy).

#### Tags:
[Microarchitecture](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) and versions are self-explanatory.

Images with *with-events-handlers* tag contain Caddy binary built with external module [events.handlers.exec](https://caddyserver.com/docs/modules/events.handlers.exec) which lets user run a script when Caddy events occur. (i.e. notify web admin when certificate is obtained/renewed or some reverse proxy upstream goes up/down). Refer to [this page](https://caddyserver.com/docs/caddyfile/options#event-options) for more details.

#### Usage:
Works with rootless docker/podman as well.

Config volume path: /config
Data volume path: /data
Default caddy config: /etc/caddy/Caddyfile
Default webroot: /srv

Here are examples:

```
podman(/docker) run \
-p 8080:80 \
--init -u http \
ghcr.io/rahilarious/gentoo-caddy:<microarch level>
```
Runs caddy which shows default webpage on port 8080.

```
podman(/docker) run \
--init -u http \
ghcr.io/rahilarious/gentoo-caddy:<microarch level> \
caddy list-modules
```
Shows modules caddy has been built with.

```
podman(/docker) run \
--init -u http \
-p 443:443 \
-v ${PWD}/Caddyfile:/Caddyfile \
-v caddy_config:/config \
-v caddy_data:/data \
-v /var/www/public_html:/usr/share/caddy \
ghcr.io/rahilarious/gentoo-caddy:<microarch level> \
caddy run --config /Caddyfile
```
Mounts volumes for config & data. Mounts the Caddyfile as well as corresponding webroot.
