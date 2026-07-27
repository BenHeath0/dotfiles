---
name: review-mr
description: Review a GitLab Merge Request or review the current branch's changes before submitting. Provide an MR link to review a remote MR, or omit it to review local branch changes.
---

# Code Review

Perform a code review — either on a GitLab MR or on the current branch before it becomes an MR.

## Additional Documentation

Additional context and guidelines live in `docs/` directories throughout the monorepo — both at the top level (`docs/`) and within packages (e.g. `packages/merchant-portal/core/docs/`). Check these when working in an unfamiliar area.

## Input

The user may provide:

- A GitLab MR URL (e.g. `https://gitlab.com/mygroup/myrepo/-/merge_requests/123`)
- A project path + MR IID (e.g. `mygroup/myrepo !123`)
- A base branch for local review (e.g. `/review-mr develop`)
- Nothing — defaults to local branch review against `main`

If it's ambiguous whether the argument is an MR reference or a base branch, ask the user to clarify.

## Mode A: Remote MR Review (MR link provided)

1. **Load GitLab tools** — Use ToolSearch with query `gitlab merge request` to load the MCP tools
2. **Fetch MR metadata** — Call `mcp__gitlab__gitlab_get_merge_request` to get the title, description, author, source/target branch, and labels
3. **Fetch the diff** — Call `mcp__gitlab__gitlab_get_merge_request_changes` to get all changed files and their diffs
4. **Review the changes** (see Review Criteria below)
5. **Write the review** (see Output Format below)
6. **Offer to post** — Ask the user: "Post this review as a comment on the MR?" If yes, call `mcp__gitlab__gitlab_create_merge_request_note` with the formatted review

## Mode B: Local Branch Review (no MR link)

1. **Detect context** — Run `git branch --show-current` to get the current branch name, and `git log <base>...HEAD --oneline` to see the commits on this branch. Default base is `main`.
2. **Get the diff** — Run `git diff <base>...HEAD` to get the full diff of all changes on this branch
3. **Read changed files** — For each changed file, read the full file to understand the broader context around the diff hunks. Use parallel reads for efficiency. If there are more than 15 changed files, ask the user which areas to focus on.
4. **Review the changes** — Use subagents in parallel (one per file or logical group) to review (see Review Criteria below)
5. **Write the review** (see Output Format below)

## Review Criteria

Review like a principal engineer. Be critical. Look for:

- **Correctness**: Logic bugs, edge cases, off-by-one errors, race conditions
- **Security**: Injection vulnerabilities, auth issues, sensitive data exposure
- **Quality**: Unnecessary complexity, duplication, poor naming, readability
- **Architecture**: Consistency with existing patterns, backwards compatibility
- **Performance**: Regressions, unnecessary allocations, missing indexes
- **Tests**: Are changes covered by tests? Are tests meaningful? Missing edge case tests?
- **Breaking changes**: API changes, schema changes, removed functionality

## Output Format

- **Summary**: 2-3 sentence overview
- **Findings**: Per-file list of issues, each with severity: `critical` / `warning` / `suggestion`
- **Verdict**: For remote MRs: Approve / Request Changes / Comment (with rationale). For local review: What to address before requesting review vs. what's fine.

## Rules

- Load MCP tools via ToolSearch before using them — they are deferred
- Do not post comments on remote MRs without explicit user confirmation
- Do NOT make any code changes — this is read-only analysis
- Focus on substance — skip stylistic nitpicks unless they affect readability significantly
- Be direct and specific: reference file paths and line numbers
- Prioritize findings by severity — lead with critical issues
- If the diff is very large (>50 files or >15 files locally), ask the user which areas to focus on
- If there are no issues, say so briefly — don't manufacture feedback
