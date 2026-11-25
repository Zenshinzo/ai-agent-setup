#!/bin/bash
# Reset Grok's config from the image on every start, so nothing the agent writes to it sticks.
# To change it, edit config.toml in this folder and rebuild.
mkdir -p "$HOME/.grok"
cp /etc/grok-seed/config.toml "$HOME/.grok/config.toml"
exec "$@"
