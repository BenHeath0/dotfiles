---
name: jira
description: Implement a Jira ticket. Fetches ticket details, asks clarifying questions, plans, and implements the work.
disable-model-invocation: true
---

# Implement Jira Ticket

Fetch a Jira ticket and implement it, asking clarifying questions before diving in.

## Input

The user provides a Jira ticket ID or URL, e.g.:
- `PROJ-123`
- `https://yourcompany.atlassian.net/browse/PROJ-123`

If no ticket is provided, ask for one before proceeding.

## Process

### 1. Fetch the ticket
Call `mcp__claude_ai_Atlassian__getJiraIssue` with the ticket ID (requires `cloudId` and `issueIdOrKey`). To get the `cloudId`, call `mcp__claude_ai_Atlassian__getAccessibleAtlassianResources` first if unknown. Extract:
- Title and description
- Ticket type (bug, feature, task, etc.)
- Acceptance criteria (if present)
- Any linked tickets or attachments worth noting

### 2. Explore the codebase
Before asking questions or planning, explore the relevant parts of the codebase to understand the current state. Look for:
- Files and modules likely affected by this ticket
- Existing patterns to follow
- Tests that already cover related functionality

### 3. Ask clarifying questions
After reading the ticket and exploring the code, identify any gaps. Ask the user targeted questions if any of the following are unclear:
- What "done" looks like (acceptance criteria)
- Which approach to take when multiple valid options exist
- Scope boundaries — what is explicitly out of scope
- Whether there are dependencies or related tickets to be aware of

Do not ask questions that can be answered by reading the ticket or the code. Keep questions focused — ask only what you genuinely need to proceed confidently.

### 4. Plan
Save an implementation plan to `.claude/plans/YYYY-MM-DD-<ticket-id>.md`. The plan should include:
- Summary of the ticket
- Files to change and why
- Implementation approach
- Testing strategy

Present the plan to the user and get approval before writing any code.

### 5. Implement
After approval, implement the changes following the plan:
- **Bug tickets**: Write a failing test that reproduces the bug first, then fix it
- **Feature tickets**: Implement the feature, then write tests
- Keep changes minimal — only what the ticket asks for
- Follow existing patterns in the codebase

### 6. Summarize
When done, provide a brief summary of what was changed and how to test it.

## Rules

- Never skip the clarifying questions step if there is genuine ambiguity
- Never start coding before the plan is approved
- Do not implement scope beyond what the ticket describes
- Do not push or create an MR — leave that to the user
