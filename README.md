# caddy-cs

Official `caddy` image plus the [caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer) HTTP handler.
Rebuilt weekly and on every merged Renovate PR, then pushed to `ghcr.io/ymickler/caddy-cs`.

Tags: `<caddy-version>`, `<caddy-version>-cs<bouncer-version>`, `latest`.

The image contains no configuration and no secrets. It is never swapped automatically on the host:
run `caddy validate` with the real Caddyfile first; rollback = previous tag.

## Updates (unattended)
- Renovate runs without pull requests or issues (both are disabled in this repository). Each update is pushed to a `renovate/*` branch,
  built and smoke-tested by CI there, and fast-forwarded into `main` only when green; `main` then publishes the image.
- Caddy and bouncer: patch and minor updates are applied automatically, major updates (e.g. Caddy 3) are disabled.
- GitHub Actions updates are applied automatically after a green CI build.
- The scheduled weekly build picks up patched base images for the same Caddy version.
- Contributions are not accepted; pull requests and issues are disabled.
