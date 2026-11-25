#!/bin/bash
# Reset agy's settings on every start (trust /work only), so nothing the agent writes to them sticks.
d="$HOME/.gemini/antigravity-cli"; mkdir -p "$d"
printf '{\n  "trustedWorkspaces": ["/work"]\n}\n' > "$d/settings.json"
exec "$@"
