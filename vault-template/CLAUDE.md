# CLAUDE.md

Read this at the start of every session.

## Who I am
- (Your name or handle, what you do, how you like answers: short, literal, no extras.)

## Where things live
- Vault: ~/vault (Obsidian, in git). Notes, plans, handoffs and daily logs all live here.
- Daily log: 98-Logs/Daily/YYYY-MM-DD.md, written with `dlog "what I did"`.
- Projects: 02-Projects/Active/<project>/ with a 00-Hub.md in each.

## How every session works
- One tmux session per job. Name it for the job.
- First thing: `session-purpose --by-claude "<what this session is for>"`.
- Every turn: `dlog` what you did, commit and push the vault.
- Handing work to another session: write a handoff note in the project folder, don't paste.

## Other agents
- Grok, Codex and agy run only in their Docker containers (see docker/). Never natively.
- They see one folder: the container's ./work. Copy in what they need, copy out what they make.
- Claude directs. The others are tools you call for a second opinion or a specific job.

## Rules
- Ask before installing anything.
- Ask before anything goes out (posts, emails, messages).
- Never put secrets in the vault or in a repo.
