# Global Claude Rules

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Everything Else

Always verify information before presenting it. Do not make assumptions or speculate without clear evidence.

### Code Style

- Before finishing any coding task, review what you wrote and ask: "Can this be simpler?" Remove any unnecessary abstraction, indirection, or generalization that isn't immediately needed.
- In Python, always use f-strings for string formatting — not %-formatting or `.format()`

### Code Comment Rules

<code_comment_rules>
When writing or editing code (excluding tests):

- Only add comments for crucial or complex logic
- Remove any superfluous comments (obvious operations, self-documenting code)
- All comments must be lowercase
- Never add docstrings unless explicitly requested
- Tests are exempt - comments are fine there
  </code_comment_rules>

### Bug Fixing Process

- When I report a bug, don't start by trying to fix it. Instead, start by writing a test that reproduces the bug. Then, have subagents try to fix the bug and prove it with a passing test.

### Plans

- When creating an implementation plan, always save it to `/Users/benheath/Developer/claude-plans` (a single shared location, not the working directory). Use the filename format `YYYY-MM-DD-<short-description>.md` (e.g., `2026-02-14-add-auth.md`). At the top of the file, put the date heading, then a **Session directories** section listing the primary working directory and any directories added to the session, then the plan content.

### Missing Tokens / Credentials

- If a task requires a token, API key, or credential and it is not present in the expected location (e.g. `~/.claude/.env`, an env var, a config file the tool points to), STOP IMMEDIATELY and ask me how to proceed.
- Do not search around for the credential in other files, do not attempt to fetch it from elsewhere, and do not try alternate auth paths. Just tell me what is missing, where you looked, and wait for direction.
