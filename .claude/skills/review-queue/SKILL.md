---
name: review-queue
description: Fetch every open GitLab MR that lists Ben (ben.heath) as a reviewer, run /review-code on each in parallel, and publish an HTML report grouped into approve / should fix / must fix, with a saved "Reviewed" checkbox per MR. Use when Ben asks for his review queue, MRs to review, or to review everything assigned to him for review.
disable-model-invocation: false
---

# Review Queue

Build Ben's review queue report. Read-only in GitLab: never post, comment, or approve anything.

Extra instructions from Ben (may be empty): $ARGUMENTS

Scripts live in `~/.claude/skills/review-queue/scripts/`. Work in `<scratchpad>/review-queue-<YYYY-MM-DD>/` (call it `WORK`), with reviews in `WORK/reviews/`.

## 1. Fetch the queue

```bash
python3 -I ~/.claude/skills/review-queue/scripts/fetch_queue.py WORK/queue.json
```

It lists open MRs with `reviewer_username=ben.heath`, drops the ones Ben has already approved, and records title, author, draft, URL, approvals left, and the local repo `review-code` skill path (if the repo is checked out under `~/Developer` and has one). If the queue is empty, tell Ben and stop.

Show Ben the printed list, then continue without waiting.

## 2. Review each MR in parallel

Launch one `kai:code-reviewer` agent per MR in a single message, all `run_in_background: true`. Prompt (fill in the `<...>` values from queue.json):

```
Run the kai `review-code` skill (full review, not a domain filter) on GitLab MR <url> (project <project>, iid <iid>).
[if draft] It is a draft MR; review it anyway.
[if repo_skill] This repo has its own `.claude/skills/review-code/SKILL.md` (DEFER mode); follow the kai skill's mode dispatch. Reading that skill and its references locally under <repo_skill dir> is fine.

Constraints:
- Use `glab` with `GITLAB_HOST=gitlab.rechargeapps.net` for all GitLab reads (metadata, diffs, source files at the MR source branch). Never read local source files for the reviewed code; the local checkout is a different branch.
- Delivery: "show here only". Do NOT post to GitLab or Slack, do not ask about delivery.
- This is read-only. Do not edit, commit, approve, or comment on anything in GitLab.

When the review is done, write a JSON file to WORK/reviews/<project last segment>-<iid>.json with exactly this shape, listing every finding labelled Must fix / Should fix (from any section, including the supplement or a repo-specific review):
{"mr": "<mr slug>", "verdict": "approve|approve after fixes|request changes", "summary": "<one sentence on what the MR does>", "note": "<'Large MR: N files, N lines' if the size check warned, else null>", "optional": "<one optional, non-blocking suggestion worth mentioning, else null>", "must_fix": [{"loc": "file:line", "issue": "<one sentence>"}], "should_fix": [{"loc": "file:line", "issue": "<one sentence>"}]}
If the size check hard-blocked the review, write one must_fix entry {"loc": "(whole MR)", "issue": "MR too large to review reliably: N files, N lines."}.
Wrap code identifiers in backticks in summary/issue text. Then return the full review text.
```

Wait for every agent to finish. If one fails or its JSON is missing or invalid, rerun that one agent. Do not write review JSON yourself from memory.

## 3. Build the page

```bash
python3 -I ~/.claude/skills/review-queue/scripts/build_report.py WORK/queue.json WORK/reviews WORK/review-queue.html
```

It exits with the list of MRs missing a review JSON; fix those first. It also writes an empty `WORK/checked.json`. The MR goes in the bucket of its most severe finding; the page and template already follow the artifact design contract, so do not redesign it.

## 4. Publish

Publish a new artifact each run (do not overwrite an earlier queue):

- `file_path`: `WORK/review-queue.html`
- `files`: `{"checked.json": "WORK/checked.json"}`
- `capabilities`: `{"artifact": {}}` (the checkboxes save by republishing `checked.json`)
- `icon`: `checklist`
- `description`: `Review findings for the N open MRs where Ben is a reviewer, with a checkbox per MR.`

Then reset the daily reminder: `touch ~/.claude/.last-review-queue`. A SessionStart hook shows a reminder when this file is missing or older than 24 hours. Also touch it when the queue is empty in step 1.

## 5. Report to Ben

Give the link, then a short summary in this order:

1. MRs to approve with no concerns.
2. MRs with should fixes, with a one-line gist of each.
3. MRs with must fixes, and what they are.

Mention large-MR warnings, MRs left out because Ben already approved them, and that findings come from automated reviews that were not re-verified.
