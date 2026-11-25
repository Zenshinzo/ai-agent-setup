#!/bin/bash
# Seed Grok's config into the home volume on first run; never overwrite a later edit.
mkdir -p "$HOME/.grok"
[ -f "$HOME/.grok/config.toml" ] || cp /etc/grok-seed/config.toml "$HOME/.grok/config.toml"
exec "$@"
