#!/bin/sh
# Fake curl: intercepts tagpr install.sh requests and serves a canned payload.
# Supports both "curl URL | sh" (stdout) and hardened "curl -o FILE URL" forms.

FAKE_INSTALL="$GITHUB_WORKSPACE/tests/fixtures/fake-install.sh"

out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
done

case "$*" in
  *tagpr*install.sh*)
    if [ -n "$out" ]; then
      cat "$FAKE_INSTALL" > "$out"
    else
      cat "$FAKE_INSTALL"
    fi
    exit 0
    ;;
esac

exec /usr/bin/curl "$@"
