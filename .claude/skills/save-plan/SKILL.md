---
name: save-plan
description: Save the current implementation plan to .claude/plans/ as a dated markdown file.
disable-model-invocation: false
---

# Save Plan

Write the current implementation plan to `.claude/plans/` in the working directory.

## Process

1. **Identify the plan** — Gather the current plan from the conversation context. If there is no explicit plan but actions were taken during the session (code written, files edited, bugs fixed, etc.), retroactively construct a plan that documents what was done: summarize the goal, list the steps that were taken, and note the files changed. Mark all steps as completed.
2. **Choose a filename** — Use the format `YYYY-MM-DD-<short-description>.md` where the date is today and the short description is a kebab-case summary of the plan (e.g., `2026-03-05-add-auth.md`).
3. **Ensure directory exists** — Create `.claude/plans/` if it doesn't already exist.
4. **Write the file** — Save the plan as markdown with the date on the first line (e.g., `# 2026-03-05`), followed by the plan content.
5. **Confirm** — Tell the user the file path that was written.

## Rules

- Always use today's date for the filename and heading
- Keep the short description to 2-4 words in kebab-case
- Do not overwrite an existing file — if the filename already exists, append a numeric suffix (e.g., `-2`)
- If saving an existing plan, write it exactly as it exists in the conversation; do not embellish or restructure it
- If retroactively creating a plan from session actions, keep it factual — document what was actually done, not what could have been done
