# Code style (core, always applies, treat this as gospel for subsequent prose)

House style for any code you write. The "Hard no" section lists banned
AI-isms. Before writing a language, read its module in ~/.claude/style/:
typescript.md (TypeScript/React), rust.md, c.md, sql-ci.md (SQL and GitHub
Actions). Registers: [work] = employer repos, [personal] = everything else,
untagged = both.

Escape hatch: these are defaults born of judgment, not law. When a rule fights
clarity or correctness, break it and say so in your reply, never in a code
comment. Contorting code to satisfy this doc is itself a violation.

## Shape

- Flat control flow above all else: guard clauses, early returns, `continue`
  guards (with a skip log). 3+ nesting levels or an else-ladder means the
  function needs reshaping.
- Space code in paragraphs: blank line between logical steps (setup, guards,
  work, result), never within one. Guards packed at the top, blank line
  before the real work starts.
- FP lean: pure transforms over mutation, expressions over statements. Not
  dogma; `let x = base; if (cond) x = other;` beats a clever pipeline.
- Repo formatter/linter config is law; no per-file overrides. The file's
  local idiom beats this doc.
- Lean deps: stdlib or a few hand-rolled lines before a new package; never
  duplicate an installed dep. No speculative abstraction: one-impl
  interfaces, single-caller helpers, config knobs for constants.
- New platform APIs freely in server/CLI code; check the browser support
  floor first.
- Validate at trust boundaries only; internals trust their callers, no
  defensive re-checks.
- Big files fine; extract helpers only for a clarifying pure transform or 2+
  call sites. Tests: repo's layout, behavior not implementation, none for
  trivia.
- No emoji anywhere, ever. Unicode typography in code (`→ – — °`) and numeric
  separators (`65_535`) are fine.

## Comments

- Near-zero density; code self-comments via names and paragraph spacing. When
  in doubt, don't. Why-only, 1-2 lines, never narrating the next line.
  Slightly more in risky logic (money, auth), but still no running
  commentary.
- Doc comments on exported public API only; never `@param` prose restating
  types.
- Justify every escape hatch inline: `!` casts, lint disables,
  `#[allow(..., reason = "...")]`.
- TODOs rare and discouraged: the tracker holds work, not the source. Comment
  voice blunt and dry; pointed asides allowed but VERY rare. Don't perform
  personality, don't hedge.
- Never generate new commented-out/parked code; preserve existing residue.
- Stacked `//` for multi-line prose, sentence case. Regex comments show a
  worked example.

## Naming

- Predicate booleans: `is`/`has`/`can`/`should`. Disambiguating names
  (`created_datetime` not `created`); unit suffix only when deviating from SI
  (`startDatetimeMs`; plain `timeout` is seconds).
- [work] No abbreviations (`index`, not `idx`; `index += 1`). Collections
  suffixed, never pluralized (`labelList`, `xByYMap`). Lexicographic
  member/key/prop sorting (`id`/`name` lead). Acronyms `Id`. Files
  kebab-case.
- [personal] `opts`/`pkg`/`req`/`ctx` fine; short predicate params
  (`.find(p => ...)`). Acronyms `ID`/`URL`. PascalCase files for type-centric
  modules, kebab-case otherwise.

## Errors and flow

- Surgical try/catch: wrap only the fallible expression; parse failure
  degrades to `null` via a small IIFE. Catches act: report, map to a typed
  error, or surface user feedback. Bare catch only for a deliberate
  swallow-to-toast.
- Chain wrapped errors: `new Error("...", { cause })`. Narrow
  (`instanceof Error`) before `.message`.
- Async: sequential awaits by default; `Promise.all` when one failure should
  fail the batch; `allSettled` when partial failure is expected and handled;
  racing is a rare weapon of power.
- `switch`: block-scoped declaring cases, explicit `default`, no fallthrough.
  Ternaries for value selection only, never side effects.

## Commits and diffs

- [personal] `type(scope): lowercase imperative subject`. [work]
  Sentence-case imperative, no prefix. No trailing period. Bodies rare: one
  candid WHY sentence or terse specific bullets plus an issue ref; never
  multi-paragraph narratives or Summary/Changes/Testing templates.
- Surgical diffs: only the task's lines; no drive-by reformatting, import
  shuffles, or cleanup.

## Hard no (AI tells)

- Placeholders: stubs, `// ... rest unchanged`, fake data, hardcoded "for
  now" returns. Ship the real thing or nothing.
- Conversation leakage: comments, names, or commit text that echo the chat
  ("as requested", "we don't need X here") or argue against alternatives that
  never existed in the file. Comments address a reader who never saw the
  chat.
- Everything above phrased "never" or "only" is equally hard.
