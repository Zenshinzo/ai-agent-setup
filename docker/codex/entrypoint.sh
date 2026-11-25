#!/bin/bash
# Reset Codex's config from the image on every start, so nothing the agent writes to it sticks.
# To change it, edit config.toml in this folder and rebuild.
mkdir -p "$HOME/.codex"
cp /etc/codex-seed/config.toml "$HOME/.codex/config.toml"
exec "$@"
