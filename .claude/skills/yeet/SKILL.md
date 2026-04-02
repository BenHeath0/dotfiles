---
name: yeet
description: Commit, push, and open a draft MR in one shot. Runs /commit, pushes the branch, then runs /write-mr to create a draft merge request.
disable-model-invocation: true
---

# Yeet

Commit staged/unstaged changes, push the branch, and create a draft MR.

## Process

1. **Check branch** — Get the current branch name. If it is `main`, `master`, or `stage`, **immediately stop** and alert the user. Do not proceed with any commits, pushes, or MR creation.
2. **Simplify** — Run the `/simplify` skill to review changed code for reuse, quality, and efficiency, and fix any issues found. Wait for it to complete before proceeding.
3. **Commit** — Run the `/commit` skill to stage and commit all pending changes. Wait for it to complete before proceeding.
4. **Push** — Push the current branch to origin with tracking:
   ```
   git push -u origin <current-branch>
   ```
5. **Create draft MR** — Run the `/write-mr` skill to create the draft MR. Wait for it to complete.
6. **Report** — Output the MR URL so the user can navigate to it.

## Rules

- Always run `/commit` first — do not skip it even if there appear to be no changes (the commit skill will handle that gracefully)
- Do not force-push — use a plain `git push -u origin <branch>`
- If the push fails because the remote branch has diverged, stop and tell the user; do not rebase or reset automatically
