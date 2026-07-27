---
name: save-plan
description: Save the current implementation plan to /Users/benheath/Developer/claude-plans as a dated markdown file.
disable-model-invocation: false
---

# Save Plan

Write the current implementation plan to `/Users/benheath/Developer/claude-plans` (a single shared location for all plans, regardless of which project you are working in).

## Process

1. **Identify the plan** — Gather the current plan from the conversation context. If there is no explicit plan but actions were taken during the session (code written, files edited, bugs fixed, etc.), retroactively construct a plan that documents what was done: summarize the goal, list the steps that were taken, and note the files changed. Mark all steps as completed.
2. **Choose a filename** — Use the format `YYYY-MM-DD-<short-description>.md` where the date is today and the short description is a kebab-case summary of the plan (e.g., `2026-03-05-add-auth.md`).
3. **Ensure directory exists** — Create `/Users/benheath/Developer/claude-plans` if it doesn't already exist.
4. **Write the file** — Save the plan as markdown with this structure:
   - First line: the date as a heading (e.g., `# 2026-03-05`)
   - Next, a **Session directories** section listing the primary working directory and any additional directories added to the session (via `/add-dir`). Use the directories shown in the environment context. Example:

     ```
     ## Session directories

     - /Users/benheath/dotfiles (primary)
     - /Users/benheath/other-project (added)
     ```

   - Then the plan content.
5. **Confirm** — Tell the user the file path that was written.

## Rules

- Always save to `/Users/benheath/Developer/claude-plans` — never to `.claude/plans/` in the working directory
- Always use today's date for the filename and heading
- Always include the **Session directories** section at the top, after the date heading
- If only the primary working directory is present (no extra directories were added), still list it and note that no additional directories were added
- Keep the short description to 2-4 words in kebab-case
- Do not overwrite an existing file — if the filename already exists, append a numeric suffix (e.g., `-2`)
- If saving an existing plan, write it exactly as it exists in the conversation; do not embellish or restructure it
- If retroactively creating a plan from session actions, keep it factual — document what was actually done, not what could have been done
