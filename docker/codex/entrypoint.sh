#!/bin/bash
# Seed Codex config into the home volume on first run; never overwrite a later edit.
mkdir -p "$HOME/.codex"
[ -f "$HOME/.codex/config.toml" ] || cp /etc/codex-seed/config.toml "$HOME/.codex/config.toml"
exec "$@"
