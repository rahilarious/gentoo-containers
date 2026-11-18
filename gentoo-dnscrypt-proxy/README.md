### [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy/)

A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 including Post-Quantum DNSCrypt (DNSCrypt 2026), DNS-over-HTTPS, Anonymized DNSCrypt and ODoH (Oblivious DoH) written in Go. Gentoo variant is optimized for your CPU.

#### Usage:

```
podman(/docker) run --name dnscrypt-proxy\
    --restart unless-stopped\
    -u dnscrypt-proxy\
    -v /my/own/etcdir:/etc/dnscrypt-proxy\
    -v /my/own/cachedir:/var/cache/dnscrypt-proxy\
    -p 53:53/tcp -p 53:53/udp\
    -p 8080:8080/tcp
    -d ghcr.io/rahilarious/gentoo-dnscrypt-proxy:<microarch-level>
```
