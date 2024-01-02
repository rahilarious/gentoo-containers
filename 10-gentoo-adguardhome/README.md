### AdGuard Home

Free and open source, powerful network-wide ads & trackers blocking DNS server [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome/) alternative to Pi-Hole written in Go. Gentoo variant is optimized for your CPU.

This image is compatible with official AdGuard Home image at https://hub.docker.com/r/adguard/adguardhome

#### Usage:

```
podman(/docker) run --name adguardhome\
    --restart unless-stopped\
    -v /my/own/workdir:/opt/adguardhome/work\
    -v /my/own/confdir:/opt/adguardhome/conf\
    -p 53:53/tcp -p 53:53/udp\
    -p 67:67/udp -p 68:68/udp\
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp\
    -p 853:853/tcp\
    -p 784:784/udp -p 853:853/udp -p 8853:8853/udp\
    -p 5443:5443/tcp -p 5443:5443/udp\
    -d ghcr.io/rahilarious/gentoo-adguardhome:<microarch-level>
```
