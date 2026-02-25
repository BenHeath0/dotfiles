---
name: yeet
description: Commit, push, and open a draft MR/PR in one shot. Runs /commit, pushes the branch, then creates a draft merge/pull request.
---

# Yeet

Commit staged/unstaged changes, push the branch, and create a draft MR/PR.

## Process

1. **Check branch** — Get the current branch name. If it is `main`, `master`, or `stage`, **immediately stop** and alert the user. Do not proceed with any commits, pushes, or MR creation.
2. **Commit** — Run the `/commit` skill to stage and commit all pending changes. Wait for it to complete before proceeding.
3. **Detect remote platform** — Inspect the remote URL to determine which CLI to use:
   - GitLab (`gitlab.com` or self-hosted GitLab): use `glab`
   - GitHub (`github.com`): use `gh`
4. **Push** — Push the current branch to origin with tracking:
   ```
   git push -u origin <current-branch>
   ```
5. **Create draft MR/PR** — Create a draft merge/pull request:
   - GitLab: `glab mr create --draft --fill`
   - GitHub: `gh pr create --draft --fill`
6. **Report** — Output the MR/PR URL so the user can navigate to it

## Rules

- Always run `/commit` first — do not skip it even if there appear to be no changes (the commit skill will handle that gracefully)
- Do not force-push — use a plain `git push -u origin <branch>`
- If the push fails because the remote branch has diverged, stop and tell the user; do not rebase or reset automatically
- Use `--fill` so the MR/PR title and description are populated from the commit messages automatically
- If neither `gh` nor `glab` is available, tell the user and stop after pushing
