---
name: write-mr
description: Create a draft GitLab MR from the current branch's changes using glab. Generates a filled-in description from the diff and creates the MR.
---

# Write MR

Create a draft GitLab MR from the current branch's changes.

## Input

The user may optionally provide:

- A base branch to diff against (e.g. `/write-mr develop`)

If no base branch is provided, default to `master`.

## Process

1. **Get context** — Run these in parallel:
   - `git branch --show-current`
   - `git log <base>...HEAD --oneline` to see commits on this branch
   - `git diff <base>...HEAD --stat` to see which files changed
   - `git diff <base>...HEAD` to get the full diff
2. **Read changed files** — For files where the diff alone isn't enough to understand intent, read the full file for context. Use parallel reads.
3. **Fill in the template** — Using the diff, commit messages, and file context, write a complete MR description following the template below. Every section must be filled in thoughtfully — do not leave placeholders or TODOs.
4. **Create the MR** — Use `glab` to create a draft MR:
   ```
   glab mr create --draft --title "<title>" --description "<body>" --yes
   ```
   Use a heredoc for the description body to preserve formatting.
5. **Report** — Output the MR URL so the user can navigate to it.

## Template

```markdown
## Summary

<!-- 2-4 sentences: what changed and why -->

## Type of change

<!-- Keep only the lines that apply, delete the rest -->

- Bug fix (non-breaking change which fixes an issue)
- Hotfix (a quick change to solve an immediate problem)
- New feature (non-breaking change which adds functionality)
- Refactor (Making code better, but intended function still the same)
- Breaking change (fix or feature that could cause existing functionality to not work as expected)
- Logging / alerting change (changes to logging level, message, or context only)
- CI change
- Documentation Change

## How to QA

<!-- Bulleted list of concrete steps a reviewer can follow to verify the changes -->

## Voice and tone rules

These rules are derived from Ben's actual MR writing style. Follow them closely.

### Style

- Casual bullet points over prose
- One idea per bullet
- If a sentence would need a comma, split it into two bullets instead
- No compound sentences
- Keep it scannable - someone skimming the MR should get the gist in seconds
- This is a rough draft to supplement the diff, not formal documentation

### Lead with context, not the diff

- For non-trivial changes, start with a **Background** or **Context** section before the Summary explaining the problem, why it exists, and link to where the discussion happened (Slack thread, Sentry alert, related MR)
- For simple changes (package bumps, copy changes, config tweaks), keep the summary to one line. Don't pad it out.

### Link everything

- Link to related MRs, Slack threads, Sentry issues, Splunk queries, admin tools, store pages — anything that gives the reviewer context
- Don't describe what a link says — just link it and let the reviewer click through
- Use inline links, not reference-style

### QA should be concrete and opinionated

- Tell the reviewer exactly what to do: which store to use, which endpoint to hit, what the expected behavior is
- Include real URLs: preprod links, Splunk queries, admin console URLs, store pages
- Include curl commands for API changes, wrapped in `<details>` blocks if long
- Reference specific test stores by name or ID when relevant
- Use checkboxes (`- [ ]`) for multi-step QA
- Say what environment the code is deployed to: "This is deployed to stage", "Run this branch on preprod"
- Never say "run the tests" — CI handles that. Focus on manual verification only.

### Show the bug, don't just describe it

- When fixing a bug, show the actual error message, payload, or code that was wrong
- Use code blocks to show before/after or the problematic state
- Include the debugging story if it helps the reviewer understand ("I tested this locally by changing X and sending Y")

## General rules

- Always use `glab` — this project is on GitLab
- Always pass `--yes` to `glab mr create` to avoid interactive prompts
- If you cannot determine something from the code (e.g. a specific Splunk query or test store), write a reasonable placeholder the user can refine, and flag it with **[needs input]**
- Do NOT make any code changes — this is read-only
- Keep the MR title under 70 characters
- Do NOT include "Co-Authored-By: Claude..." in the MR description
```
