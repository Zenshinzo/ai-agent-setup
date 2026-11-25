#!/bin/bash
# Seed agy settings into the home volume on first run (trust /work only); never overwrite a later edit.
d="$HOME/.gemini/antigravity-cli"; mkdir -p "$d"
[ -f "$d/settings.json" ] || printf '{\n  "trustedWorkspaces": ["/work"]\n}\n' > "$d/settings.json"
exec "$@"
