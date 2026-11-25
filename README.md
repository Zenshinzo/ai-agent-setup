# AI agent setup

How I run Claude Code day to day, plus Grok Build, Codex and Antigravity (agy) as tools,
each locked in its own Docker container.

Write-up: [7 Habits of My AI Agent Setup](https://zenshinzo.com/words/7-habits-of-my-ai-agent-setup/)

## What's here

| Path | What it does |
|---|---|
| `bin/tmux-picker` | On ssh login: pick a tmux session or start a new one with Claude in it |
| `bin/claude-main-session` | Keeps one Claude (with Remote Control) running in tmux from boot |
| `bin/session-snap` | Records every tmux session and its Claude conversation |
| `bin/session-restore` | After a reboot: brings the sessions back and resumes each conversation |
| `bin/session-purpose` | One line saying what each session is for (`session-purpose --list` shows them all) |
| `bin/dlog` | Appends a timestamped line to today's log in the vault (optional Discord mirror) |
| `tmux/tmux.conf` | Hooks that run `session-snap` when a session opens, closes or is renamed |
| `docker/grok`, `docker/codex`, `docker/agy` | One locked-down container per agent |
| `vault-template/CLAUDE.md` | A starter instructions file for your vault |

## Install

Linux or macOS, with tmux, Python 3.9+, and Claude Code. Make sure `~/.local/bin` is on your PATH.

    mkdir -p ~/.local/bin
    for f in bin/*; do install -m 755 "$f" ~/.local/bin/; done
    cat tmux/tmux.conf >> ~/.tmux.conf
    tmux source-file ~/.tmux.conf 2>/dev/null || true   # if tmux is already running

Snapshot every 10 minutes too, so a session's conversation is on record even if nothing
opens or closes before a reboot (`crontab -e`):

    */10 * * * * $HOME/.local/bin/session-snap

Start the picker on every ssh login (add to `~/.bashrc` or `~/.zshrc`):

    if [ -r "$HOME/.local/bin/tmux-picker" ]; then
      TMUX_PICKER_RC=1
      . "$HOME/.local/bin/tmux-picker"
      unset TMUX_PICKER_RC
    fi

Vault: the scripts look for `$AGENT_VAULT`, then `~/vault`. Put a timezone name
(for example `America/New_York`) in `~/vault/.vault-tz` so every machine logs the same day.
Without it, logs use UTC.

Start Claude at boot inside tmux (Linux, `crontab -e`):

    @reboot tmux new-session -d -s main "$HOME/.local/bin/claude-main-session"

On macOS, skip `@reboot`: a tmux server started outside your login session can't reach the
keychain, so Claude comes up logged out. Open tmux from Terminal instead.

Name each Claude after its session so restore can find it: `claude -n "<host>: <session>"`.
The picker does this for you. After a reboot, run `session-restore`.

Discord mirror for `dlog` (optional): put a channel webhook URL in `~/.config/dlog/webhook`.

## The containers

Each agent gets:

- its own user (uid 2001 Grok / 2002 Codex / 2003 agy), not root
- a read-only root filesystem, all Linux capabilities dropped, no privilege escalation
- one host folder (`./work`, mounted at `/work`) plus a private volume for its login
- a fresh container per run (`run --rm`)

What it does NOT stop: the agent can read and change anything in `./work`, and its login
lives in its volume. It also has normal network access, which on a default Docker network
includes your LAN, your Tailscale peers and any cloud metadata endpoint. Only put in `./work`
what you'd hand to that company anyway, and if that reach matters to you, block those ranges
for containers with `DOCKER-USER` firewall rules.

Each agent's safety settings (`config.toml`, agy's `settings.json`) are reset from the image on
every start, so the agent can't loosen them for next time. Edit them here and rebuild.

| Folder | Compose service | uid |
|---|---|---|
| `docker/grok` | `grok` | 2001 |
| `docker/codex` | `chatgpt` | 2002 |
| `docker/agy` | `gemini` | 2003 |

Set up a container (Grok shown):

    cd docker/grok
    mkdir -p work && sudo chown 2001:2001 work
    docker compose build
    docker compose run --rm grok grok login --device-auth

Use it: copy a file into `docker/grok/work/`, then

    docker compose run --rm grok grok -p "review plan.md"

Codex: `docker compose run --rm chatgpt codex login --device-auth`, then
`docker compose run --rm -T chatgpt codex exec --skip-git-repo-check "review plan.md" < /dev/null`.

agy: Google's binary isn't included. Copy it in first (see `docker/agy/README.md`), then
`docker compose run --rm gemini agy` to sign in.
Codex is set to a read-only sandbox by default (`docker/codex/config.toml`).
Grok has every Claude/Cursor/Codex compatibility import switched off (`docker/grok/config.toml`).

To remove an agent completely: `docker compose down --rmi all --volumes`, then delete its `work/` folder.

## Not in this repo

The article also mentions an end-of-turn hook that reminds Claude to log, and Claude's memory
folder linked into the vault. Those are part of my personal Claude config, not these scripts.

## License

MIT. See `LICENSE`.
