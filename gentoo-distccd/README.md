### Fasten your emerges with distcc

With this container you can run distccd on any distro. But one has to make sure *GCC* & *binutils* versions are same (or atleast close enough i.e. gcc 12.2.1 & 12.2.2 might work) across all distcc nodes.

Run following command to know versions `emerge --info sys-devel/gcc sys-devel/binutils`

#### Usage:
Works with rootless docker/podman as well. 

```
podman(/docker) run \
-p 3632:3632 \
--init -u distcc \
--mount type=tmpfs,destination=/tmp,tmpfs-size=75% \
--mount type=tmpfs,destination=/var/tmp,tmpfs-size=75% \
ghcr.io/rahilarious/gentoo-distccd:<microarch level>
```

Distccd will allow traffic from any _private_ network with niceness 15 by default.

```
podman(/docker) run \
-p 3632:6969 \
--init -u distcc \
--mount type=tmpfs,destination=/tmp,tmpfs-size=75% \
--mount type=tmpfs,destination=/var/tmp,tmpfs-size=75% \
ghcr.io/rahilarious/gentoo-distccd:<microarch level> \
--allow 10.0.0.0/24 --port 6969 --nice 13 --log-level debug
```

This will only _allow_ traffic from subnet 10.0.0.0/24 listening on _port_ 6969/tcp with _niceness_ 13 and more verbose logs. More info on distccd(1)

