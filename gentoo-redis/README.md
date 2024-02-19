### Redis

Run [Redis - an in-memory database that persists on disk](https://redis.io) anywhere with binary which is optimized for your CPU.

#### Usage

This image is compatible with [official redis image](https://hub.docker.com/_/redis). So checkout their documentation for details.

#### Examples:

Run Redis in its default form
```
podman(/docker) run \
-v redis-data:/data \
-p 6379:6379 \
-u redis \
ghcr.io/rahilarious/gentoo-redis:<microarch-level>
```
Run Redis with your own config
```
podman(/docker) run \
-v redis-data:/data \
-v /path/to/your/redis.conf:/etc/redis/redis.conf
-p 6379:6379 \
-u redis \
ghcr.io/rahilarious/gentoo-redis:<microarch-level> \
/usr/sbin/redis-server /etc/redis/redis.conf
```
