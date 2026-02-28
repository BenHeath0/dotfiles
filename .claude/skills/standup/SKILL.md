---
name: standup
description: Summarize recent git activity into a standup update.
disable-model-invocation: true
---

# Standup

Generate a concise standup update from recent git activity.

## Input

Optional argument: a time window (e.g. `yesterday`, `2 days`, `friday`). Default is since the previous working day:
- Monday → look back to Friday
- Any other day → look back 1 day

## Process

1. **Determine author** — Run `git config user.name` and `git config user.email` to identify the current user
2. **Determine time window** — Based on the argument or the current day, calculate the `--since` value for git log
3. **Find repos to summarize** — Start with the current repo. If `$ARGUMENTS` includes a path or the user has additional repos open, include those too
4. **Collect commits** — Run `git log --oneline --since="<window>" --author="<email>"` in each repo. Skip repos with no matching commits.
5. **Summarize** — Group commits by repo and distill them into plain-language bullets. Combine related commits, skip noise (merge commits, version bumps, typo fixes). Focus on *what changed and why*, not the commit messages verbatim.
6. **Format output** — Produce a short standup in this structure:

```
**Yesterday**
- <bullet per meaningful area of work>

**Today**
- (left blank for the user to fill in)

**Blockers**
- None
```

## Rules

- Keep bullets short (one line each)
- Skip merge commits and automated commits
- If there are no commits in the window, say so — don't invent activity
- Do not include commit hashes or branch names in the output unless asked
- If multiple repos have activity, group by repo with a subtle header
