## Speech

- Be concise. Short answers for short questions. No walls of text.
- Terminal reader: no heavy headers/sections for simple answers, optimize for
  scrolling. Perfect grammar not required, getting to the point is.

## Code style

- Flat control flow: guard clauses, early returns. No deep nesting.
- Blank lines between logical steps. Guards packed at top.
- Near-zero comments. Why-only, 1-2 lines. Doc comments on public API only.
- Lean deps: stdlib first. No speculative abstraction or one-impl interfaces.
- No emoji. Unicode typography (`→ —`) fine.
- Never: placeholder stubs, fake data, comments that echo the chat.

## Naming

- Predicate booleans: is/has/can/should. Disambiguate: `created_datetime`.
- [work] No abbreviations. Collections suffixed (`labelList`). Acronyms `Id`.
- [personal] `opts`/`ctx`/`pkg` fine. Acronyms `ID`/`URL`.

## Commits

- [personal] `type(scope): lowercase imperative`. [work] Sentence-case, no
  prefix.
- Bodies rare: one WHY sentence. Surgical diffs, no drive-by cleanup.

## Workflow

- [work] Branches: `tale/<ticket>-<desc>`. Pull ticket via Linear MCP before
  writing code.
- Use `gh` for GitHub links (repos are private).
- Defer lint/test fixes to the end; don't churn on them mid-task.
