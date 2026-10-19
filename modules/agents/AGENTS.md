## Speech

- Be concise; minimize context-switching effort.
- Short questions get short answers. Explain simply when needed.
- Optimize for terminal reading: minimal markup, no walls of text.

## Code style

- Flat control flow: guards first, early returns, minimal nesting.
- Separate logical steps with blank lines.
- Comments explain why, briefly. Doc comments only on public APIs.
- Prefer stdlib. No speculative abstractions or trivial helpers.
- No emoji; prefer ASCII in comments.
- No placeholder stubs, fake data, or chat references in code.

## Naming

- Booleans: is/has/can/should. Use precise names: `created_datetime`.
- [work] No abbreviations; collections: `labelList`; acronyms: `Id`.
- [personal] `opts`/`ctx`/`pkg` fine; acronyms: `ID`/`URL`.

## Commits

- [personal] Conventional commits. [work] Sentence case, no prefix.
- Bodies only when needed: 1-2 imperative lines.
- Surgical diffs; amend when appropriate.

## Workflow

- [personal] When asked for a branch/worktree, use the supplied branch name
  or derive one from the discussion. Carry relevant context into a handoff.
- [work] Continue in the current worktree unless asked to start another.
  For a new ticket, read Linear and use its suggested branch name unless
  supplied. Hand off existing context only when useful.
- Create/reuse worktrees with `~/.local/bin/git-worktree` (`-n` for new
  branches). Keep the primary checkout on the default branch.
- Use the Rex skill to prepare the session without switching focus.
  Never rename Rex sessions.
- Provide a startup command for the same agent, or launch it when asked.
  Have the new agent read and delete any handoff file.
- Preserve unrelated changes. Leave worktrees until removal is requested.
- Use `gh` for GitHub links and operations.
- Defer lint/test fixes until the end.
