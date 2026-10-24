# caddy-cs

Official `caddy` image plus the [caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer) HTTP handler.
Rebuilt weekly and on every merged Renovate PR, then pushed to `ghcr.io/ymickler/caddy-cs`.

Tags: `<caddy-version>`, `<caddy-version>-cs<bouncer-version>`, `latest`.

The image contains no configuration and no secrets. It is never swapped automatically on the host:
run `caddy validate` with the real Caddyfile first; rollback = previous tag.

## Updates
- Renovate bumps both `FROM caddy:*` tags (grouped) and the bouncer version (`ARG BOUNCER_VERSION`, regex manager, `go` datasource).
- Only patch updates are automerged; minor and major updates need a manual merge (overrides the shared preset).
- The scheduled weekly build picks up patched base images for the same Caddy version.
