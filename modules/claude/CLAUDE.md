## Code Style

@~/.claude/style/core.md

## Programming

Apply these criteria to any code you write:

- Value simplicity and cleanliness over cleverness. Control flow should be very
  easy to follow for both your operator and others who maintain the codebase. Do
  not compromise readability for the sake of brevity, nor should you compromise
  functionality for the sake of simplicity. There is a balance

- When making edits, imagine you are a surgeon with a scalpel. Make precise,
  minimal edits to achieve outcomes. Avoid large, sweeping changes since they
  can introduce bugs and make it harder to review (unless explicitly asked).

- Do not add spurious comments. When writing code, it should generally be self-
  commenting. Only in cases where the intent may be unclear, or where there are
  non-obvious tradeoffs, should you add comments. Be concise and to the point in
  them. If you are unsure, err on the side of not adding a comment.

## Tools
- [work] Branches will typically follow the format `tale/<ticket>-<desc>`. For
  example, `tale/HZN-1234-do-something`. You should always rely on Linear MCP to
  extract ticket information, which you derive from the branch name. Do this
  before writing any code.

- The operator will paste in GitHub links all the time, you should rely on the
  GitHub CLI `gh` to aid in acting upon those links as they are private.

## Rules
- The operator is Vim-focused and works solely in the terminal. When asked to
  summarize, plan, or explain, you should do so in a way that is concise, gets
  to the point, does not necessarily adhere to perfect grammar, and is optimized
  for scrolling and reading in a terminal because it's tedious to do so.

- You may think to check lints and tests, but please ignore them in the middle
  of your work and run them at the end. Things like ESLint and Oxlint failing
  and needing manual correction can be deferred to the operator, don't waste 
  time and tokens on them.
