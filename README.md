# caddy-cs

Offizielles `caddy`-Image plus [caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer) (HTTP-Handler).
Wird wöchentlich und bei jedem Renovate-Merge neu gebaut und nach `ghcr.io/ymickler/caddy-cs` gepusht.

Tags: `<caddy-version>`, `<caddy-version>-cs<bouncer-version>`, `latest`.
Enthält keine Konfiguration und keine Secrets. Der Austausch auf dem Host erfolgt nie automatisch:
vorher `caddy validate` mit dem echten Caddyfile, Rollback = vorheriges Tag.
