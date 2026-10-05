---
name: simplify-code
description: Propose-then-apply pass that strips over-engineering (unneeded abstractions, indirection, unused options) from code changed this session, and waits for approval before editing. Use when the user wants simplifications proposed for review rather than applied directly.
---

# Code Simplification Pass

Perform a final review of code changes from this session to identify and remove unnecessary complexity.

## Process

1. **Identify scope**: List files created or modified this session
2. **Review each file** for:
   - Abstractions not yet needed
   - Layers of indirection that don't add value
   - Overly generic code that only has one use case
   - Premature optimization
   - Unnecessary classes/wrappers around simple functions
   - Config or options that aren't being used
3. **Propose simplifications**: For each issue found, explain what can be removed/simplified and why
4. **Apply changes**: After user approval, make the simplifications

## Simplification Checklist

Ask for each piece of code:

- Does this abstraction have more than one concrete use right now?
- Would a simpler inline solution work just as well?
- Is this flexibility actually being used?
- Could this be a plain function instead of a class?
- Are there parameters/options that are never varied?

## Output

Provide a summary:

- Files reviewed
- Simplifications made (or proposed)
- Complexity removed (lines, classes, abstractions)
