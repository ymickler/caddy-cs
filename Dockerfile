# Caddy with the CrowdSec bouncer (HTTP handler). Renovate bumps both FROM tags and the module version.
FROM caddy:2.11.7-builder AS builder
# renovate: datasource=go depName=github.com/hslatman/caddy-crowdsec-bouncer
ARG BOUNCER_VERSION=v0.14.1
RUN xcaddy build --with github.com/hslatman/caddy-crowdsec-bouncer/http@${BOUNCER_VERSION}

FROM caddy:2.11.7
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
LABEL org.opencontainers.image.source="https://github.com/ymickler/caddy-cs" \
      org.opencontainers.image.description="Caddy + hslatman/caddy-crowdsec-bouncer (http)" \
      org.opencontainers.image.licenses="Apache-2.0"
