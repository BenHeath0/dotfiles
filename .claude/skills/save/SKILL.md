---
name: save
description: Save a write-up of what was done in the current session (findings, changes, open items) to /Users/benheath/Developer/claude-plans as a dated markdown file.
disable-model-invocation: false
---

# Save Session

Write up what happened in this session to `/Users/benheath/Developer/claude-plans` (a single shared location, regardless of which project you are working in). Write it so a new thread with zero context can pick up the work.

Focus hint from Ben (may be empty): $ARGUMENTS

## Process

1. **Check for an earlier save from this session** — search `/Users/benheath/Developer/claude-plans` for `Session: ${CLAUDE_SESSION_ID}`. If a file matches, update that file instead of creating a new one.
2. **Check git state** — for each repo modified this session, run `git status --short` and `git log --oneline -5` to fill in the Changes section. Run nothing else: no new queries, scripts, or investigation. Write from what is already in the conversation.
3. **Choose a filename** (new files only) — `YYYY-MM-DD-<short-description>.md`, using today's date and a 2-4 word kebab-case topic. If that name already exists, append a numeric suffix (e.g., `-2`).
4. **Write the file** using the format below.
5. **Confirm** — tell Ben the file path and whether it was created or updated.

## Format

```
# YYYY-MM-DD — <topic>

Session: ${CLAUDE_SESSION_ID}
Repos: <repo> (<branch> @ <short sha>), <repo> (read only)
Related: <earlier claude-plans file on the same topic>
```

Then these sections, in this order. Omit any section that would be empty.

- **Context** — what Ben asked and why, with source links (Slack, Jira, Sentry, MR, dashboards).
- **Key identifiers** — store ids, job ids, tables, tickets, branches, hosts. Use a table if there are more than a few.
- **What was done** — short list of the steps taken.
- **Findings** — conclusions and root cause, with `file:line` references.
- **Ruled out / corrections** — dead ends, disproven hypotheses, and conclusions reversed during the session.
- **Changes** — commits, uncommitted files, MRs. State plainly what is committed, pushed, merged, or deployed, and what is not.
- **Queries & commands** — final versions of SQL, PromQL, or shell commands worth reusing.
- **Open items** — unanswered questions, next steps, and anything not verified.

## Rules

- `Repos:` lists repos actually read or modified, not session directories. Include branch and short sha for modified repos; mark the rest `read only`. Omit the line if no repo was touched.
- `Related:` links earlier files in `claude-plans` covering the same topic, judged from filenames. Omit the line if none.
- Keep it factual — record what was done and found, not what could have been done. Use the final state of each conclusion; put superseded ones under Ruled out / corrections.
- If a focus hint was given, weight the write-up toward it.
- When updating an existing file, revise its sections to reflect the current state rather than appending a second copy.
