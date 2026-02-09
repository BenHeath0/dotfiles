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

When I report a bug, don't start by trying to fix it. Instead, start by writing a test that reproduces the bug. Then, have subagents try to fix the bug and prove it with a passing test.
