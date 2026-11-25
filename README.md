# AI agent setup

How I run Claude Code day to day, plus Grok Build, Codex and Antigravity (agy) as tools,
each locked in its own Docker container. Write-up: (article link)

## What's here

| Path | What it does |
|---|---|
| `bin/tmux-picker` | On ssh login: pick a tmux session or start a new one with Claude in it |
| `bin/claude-main-session` | Keeps one Claude (with Remote Control) running in tmux from boot |
| `bin/session-snap` | Records every tmux session and its Claude conversation (runs from tmux hooks) |
| `bin/session-restore` | After a reboot: brings the sessions back and resumes each conversation |
| `bin/session-purpose` | One line saying what each session is for |
| `bin/dlog` | Appends a timestamped line to today's log in the vault (optional Discord mirror) |
| `tmux/tmux.conf` | The hooks that run `session-snap` |
| `docker/grok`, `docker/codex`, `docker/agy` | One locked-down container per agent |
| `vault-template/CLAUDE.md` | A starter instructions file for your vault |

## Install

Linux or macOS, with tmux, Python 3.9+, and Claude Code.

    mkdir -p ~/.local/bin
    cp bin/* ~/.local/bin/ && chmod 755 ~/.local/bin/*
    cat tmux/tmux.conf >> ~/.tmux.conf

Start the picker on every ssh login (add to `~/.bashrc` or `~/.zshrc`):

    if [ -r "$HOME/.local/bin/tmux-picker" ]; then
      TMUX_PICKER_RC=1
      . "$HOME/.local/bin/tmux-picker"
      unset TMUX_PICKER_RC
    fi

Vault: the scripts look for `$AGENT_VAULT`, then `~/vault`. Put a timezone name
(for example `America/New_York`) in `~/vault/.vault-tz` so every machine logs the same day.

Start Claude at boot inside tmux (crontab -e):

    @reboot tmux new-session -d -s main "$HOME/.local/bin/claude-main-session"

Name each Claude after its session so restore can find it: `claude -n "<host>: <session>"`.
The picker does this for you.

## The containers

Each agent gets:

- its own user (uid 2001 / 2002 / 2003)
- a read-only filesystem, all Linux capabilities dropped, no privilege escalation
- one host folder (`./work`) plus a private volume for its login
- a fresh container per run (`run --rm`)

    cd docker/grok
    docker compose build
    docker compose run --rm grok grok login --device-auth
    docker compose run --rm grok grok -p "review ./work/plan.md"

Codex is set to a read-only sandbox by default (`docker/codex/config.toml`).
Grok has every Claude/Cursor/Codex compatibility import switched off (`docker/grok/config.toml`).
