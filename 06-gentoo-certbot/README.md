### Certbot

Run certbot anywhere using CPU-optimized python backend.

#### Usage:

Check out the built-in help:
```
podman(/docker) run --rm \
ghcr.io/rahilarious/gentoo-certbot:<microarch-level> --help
```

#### Examples:

Only issue certificate for (www.)example.com using manual DNS method
```
podman(/docker) run -it --rm \
-v certbot-var-config:/var/lib/letsencrypt \
-v certbot-etc-config:/etc/letsencrypt \
ghcr.io/rahilarious/gentoo-certbot:<microarch-level> \
certonly --manual -d example.com,www.example.com --preferred-challenges "dns-01"
```

