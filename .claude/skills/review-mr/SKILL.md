---
name: review-mr
description: Review a GitLab Merge Request. Fetches the MR diff and performs a structured code review. Optionally posts a summary comment back to GitLab.
---

# MR Code Review

Perform a code review on a GitLab Merge Request and optionally post the findings as a comment.

## Input

The user should provide one of:
- A GitLab MR URL (e.g. `https://gitlab.com/mygroup/myrepo/-/merge_requests/123`)
- A project path + MR IID (e.g. `mygroup/myrepo !123`)

If neither is provided, ask the user for the MR reference before proceeding.

## Process

1. **Load GitLab tools** — Use ToolSearch with query `gitlab merge request` to load the MCP tools
2. **Fetch MR metadata** — Call `mcp__gitlab__gitlab_get_merge_request` to get the title, description, author, source/target branch, and labels
3. **Fetch the diff** — Call `mcp__gitlab__gitlab_get_merge_request_changes` to get all changed files and their diffs
4. **Review the changes** — Analyze each changed file for:
   - **Correctness**: Logic bugs, edge cases, off-by-one errors
   - **Security**: Injection vulnerabilities, authentication/authorization issues, sensitive data exposure
   - **Quality**: Unnecessary complexity, duplication, readability
   - **Tests**: Are changes covered by tests? Are tests meaningful?
   - **Breaking changes**: API changes, schema changes, removed functionality
5. **Write the review** — Produce a structured report:
   - **Summary**: 2-3 sentence overview
   - **Findings**: Per-file list of issues (severity: critical / warning / suggestion)
   - **Verdict**: Approve / Request Changes / Comment (with rationale)
6. **Offer to post** — Ask the user: "Post this review as a comment on the MR?" If yes, call `mcp__gitlab__gitlab_create_merge_request_note` with the formatted review

## Rules

- Load MCP tools via ToolSearch before using them — they are deferred
- Do not post comments without explicit user confirmation
- Focus on substance — skip stylistic nitpicks unless they affect readability significantly
- If the diff is very large (>50 files), ask the user which areas to focus on
- Use markdown formatting in the posted comment so it renders well in GitLab
