### Squid

Run [squid - web proxy & cache](http://www.squid-cache.org/) anywhere with binary which is optimized for your CPU.

#### Usage:

Check out the squid(8) man page & official [documentation](http://www.squid-cache.org/Doc/config/)

#### Examples:

Run squid on port 3128
```
podman(/docker) run \
-v squid-logs:/var/log/squid \
-v squid-cache:/var/cache/squid \
-v squid-config:/etc/squid \
-p 3128:3128 \
ghcr.io/rahilarious/gentoo-squid:<microarch-level>
```
Run squid on host's network instead of sandboxed network which makes it faster but bit insecure
```
podman(/docker) run \
--net=host \
-v squid-logs:/var/log/squid \
-v squid-cache:/var/cache/squid \
-v squid-config:/etc/squid \
ghcr.io/rahilarious/gentoo-squid:<microarch-level>
```
