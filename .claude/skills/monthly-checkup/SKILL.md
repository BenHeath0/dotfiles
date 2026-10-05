---
name: monthly-checkup
description: Monthly Claude Code maintenance pass. Runs the CLI health checks Claude can run, then lists the slash commands for Ben to type.
disable-model-invocation: true
---

# Monthly Checkup

Check that Ben's Claude Code setup is healthy and surface features worth adopting.

## Process

1. **Run CLI checks** — run each with `< /dev/null` so none waits for input:
   - `claude doctor` — install health, version, auto-update status
   - `claude plugin marketplace update` — refresh marketplace sources
   - `claude plugin details <plugin>` for each enabled plugin in `claude plugin list` — always-on token cost
2. **Summarize** — report only problems and notable numbers: doctor issues, failed updates, any plugin over ~5k always-on tokens. Skip anything that came back clean.
3. **Hand Ben the slash commands** — print the checklist below. Claude cannot run slash commands; Ben types them.
4. **Reset the reminder** — run `touch ~/.claude/.last-checkup`. A SessionStart hook shows a reminder when this file is missing or older than 30 days.

## Checklist for Ben

Health
- `/release-notes` — skim what changed since last month
- `/doctor` — full checkup, flags unused skills
- `/mcp` — reconnect or disable servers that need auth
- `/plugin` — update installed plugins; `/kai:update-kai` for kai

Context cost
- `/context` — what loads before the first prompt
- `/skill-doctor` — per-skill cost and usage; turn off expensive, unused ones

Instructions
- `/doctor prompt-audit` — stale instructions in CLAUDE.md and skills
- `/memory` — prune CLAUDE.md and auto memory

Permissions and hooks
- `/fewer-permission-prompts` — run from `~/dotfiles` so rules land in global settings
- `/permissions` — drop stale allow/deny rules
- `/hooks` — confirm hooks are still configured as intended

Usage
- `/insights` — usage patterns, failures, features to try
- `/usage` — plan limits and activity
- `/powerup` — lessons on features not yet tried
