---
name: commit
description: Commit current changes using Conventional Commits. Analyzes pending changes, groups unrelated changes into separate focused commits, and asks for confirmation before executing.
---

# Smart Commit

Commit pending changes using Conventional Commits format. When changes are unrelated, split them into multiple focused commits.

## Process

1. **Assess changes** — Run `git status` and `git diff` (staged and unstaged) to see all pending changes
2. **Group related changes** — Analyze the diff and group changes into logical units. Each group should represent a single concern (one feature, one bug fix, one chore, etc.). Files that are part of the same logical change belong together.
3. **Determine commit order** — If multiple groups exist, order them so dependencies come first
4. **Plan commits** — For each group, prepare:
   - The list of files to stage
   - A Conventional Commits message: `type(scope): description`
5. **Show the plan** — Present all planned commits (files + messages) to the user and ask for confirmation before executing anything
6. **Execute commits** — After user approval, stage and commit each group sequentially

## Conventional Commits Format

- **Subject line:** `type: description` — under 72 characters
- **Types:** `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `build`, `ci`, `perf`
- **Scope:** omit by default. Project-level CLAUDE.md files may specify a different convention
- **Body:** only add one if the "why" isn't obvious from the subject line
- End the commit message with: `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

## Rules

- Never run `git push` — only create local commits
- Never use `git add -A` or `git add .` — always stage specific files by name
- Do not commit files that appear to contain secrets (`.env`, credentials, tokens)
- If there is only one logical group, make a single commit — don't force unnecessary splits
- Ask for user confirmation before executing any commits
