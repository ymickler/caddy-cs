#!/usr/bin/env bash
# Creates a GitHub release for a newly built image version, with the upstream release notes of
# every Caddy / bouncer release since the previous image release. Skips if the release already exists
# (e.g. weekly rebuilds of the same versions). Env: CADDY (e.g. 2.11.7), BOUNCER (e.g. v0.14.1), GH_TOKEN.
# DRY_RUN=1 prints the notes instead of creating the release.
set -euo pipefail
tag="${CADDY}-cs${BOUNCER}"
if [ -z "${DRY_RUN:-}" ] && gh release view "$tag" >/dev/null 2>&1; then echo "release $tag already exists"; exit 0; fi
prev=${PREV_TAG-$(gh release list --limit 1 --json tagName --jq '.[0].tagName // ""')}
prev_caddy=""; prev_bouncer=""
if [ -n "$prev" ]; then prev_caddy=${prev%%-cs*}; prev_bouncer=${prev#*-cs}; fi

# Upstream text must not ping people or link to issues of this repository.
neutralize() { sed -E 's/@([A-Za-z0-9])/@\xE2\x80\x8B\1/g; s/(^|[^A-Za-z0-9\/&])#([0-9]+)/\1#\xE2\x80\x8B\2/g'; }

# Stable upstream releases with version in (from, to]; from empty = only "to".
vle() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" = "$1" ]; }   # $1 <= $2
releases_between() { # repo from to (versions without leading v): stable releases with from < v <= to
  local repo=$1 from=$2 to=$3 v
  for v in $(gh api "repos/$repo/releases?per_page=50" --jq '.[] | select(.prerelease|not) | select(.draft|not) | .tag_name' \
             | sed 's/^v//' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V); do
    if [ -z "$from" ]; then [ "$v" = "$to" ] && echo "$v"
    elif [ "$v" != "$from" ] && vle "$from" "$v" && vle "$v" "$to"; then echo "$v"; fi
  done
}

section() { # title repo from to
  local title=$1 repo=$2 from=${3#v} to=${4#v}
  if [ "$from" = "$to" ]; then echo "## $title $to (unchanged)"; echo; return; fi
  echo "## $title ${from:+$from → }$to"; echo
  local v
  for v in $(releases_between "$repo" "$from" "$to" | sort -Vr); do
    echo "### $title $v"
    echo "Upstream: https://github.com/$repo/releases/tag/v$v"; echo
    gh api "repos/$repo/releases/tags/v$v" --jq .body 2>/dev/null | neutralize | sed -E 's/^(#{1,4}) /\1## /' || echo "_No release notes found._"
    echo
  done
}

{
  echo "Image: \`ghcr.io/ymickler/caddy-cs:${CADDY}\` · \`ghcr.io/ymickler/caddy-cs:${tag}\`"
  echo
  if [ -n "$prev" ]; then echo "Changes since \`$prev\`."; else echo "First release of this image."; fi
  echo
  section "Caddy" caddyserver/caddy "$prev_caddy" "$CADDY"
  section "caddy-crowdsec-bouncer" hslatman/caddy-crowdsec-bouncer "$prev_bouncer" "$BOUNCER"
} > release-notes.md

if [ -n "${DRY_RUN:-}" ]; then cat release-notes.md; exit 0; fi
gh release create "$tag" --title "Caddy $CADDY + CrowdSec bouncer $BOUNCER" --notes-file release-notes.md --target "${GITHUB_SHA:-main}"
