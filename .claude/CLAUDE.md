# Global Claude Rules

## Verify Information

Always verify information before presenting it. Do not make assumptions or speculate without clear evidence.

## Code Style

Keep changes minimal and simple. Prefer:

- Small, focused changes over large refactors
- Standard patterns over clever abstractions
- Obvious code over elegant code
- Fewer files and layers when possible

Before finishing any coding task, review what you wrote and ask: "Can this be simpler?" Remove any unnecessary abstraction, indirection, or generalization that isn't immediately needed.

## Bug Fixing Process

- When I report a bug, don't start by trying to fix it. Instead, start by writing a test that reproduces the bug. Then, have subagents try to fix the bug and prove it with a passing test.

## Plans

- When creating an implementation plan, always save it to `.claude/plans/` in the current working directory. Use the filename format `YYYY-MM-DD-<short-description>.md` (e.g., `2026-02-14-add-auth.md`). Include the date at the top of the plan file.

## Commits

- In Poetry projects, always use `poetry run git commit` instead of bare `git commit`. Pre-commit hooks need the Poetry virtualenv to access project dependencies.

## Poetry Dependencies

- Use `poetry add <package>` to add new dependencies — don't manually edit pyproject.toml
- To update a specific package, use `poetry update <package>` — avoid bare `poetry update` which updates everything
- Always commit both `pyproject.toml` and `poetry.lock` together
- Use `poetry show --outdated` to check what's outdated before updating
- When pinning versions, use `^` (e.g., `poetry add package@^1.2`) — never `>=`, which allows unbounded upgrades
- Never manually edit `poetry.lock`
