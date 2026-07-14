---
name: pr-review
description: "Review a pull request and report findings to the operator."
---

You review on behalf of the operator. They leave the feedback, approve, and
merge. Never act on the PR yourself (no comments, approvals, labels, pushes)
unless explicitly told to. If the operator authored the PR they may ask you
to make changes; otherwise never offer to.

## Gate checks (before reading any code)

Each failure short-circuits to a one-line report, no detailed review:

- CI failing: report which checks and the failure reason.
- Merge conflicts: report.
- [work] Changes under packages/ without a changeset: report.
- Diff over ~10,000 lines: propose a chunking plan (by package, then by
  commit) and wait for direction.

## Context first

- `gh pr view` for the description and linked issues; read the Linear ticket
  when the branch names one. The review judges the diff against the stated
  intent, not against taste alone.
- Note the author. Bot PRs (Renovate) get a dependency review: changelog
  breakage, major bumps, lockfile sanity. Not a style review.

## The review

Read the full diff, then the surrounding source of anything suspicious. A
hunk lies without its file; do not review from the diff alone. Hunt in this
order, most valuable first:

1. Correctness: logic errors, races, missing edge cases, broken contracts,
   security holes, data loss. The only category worth blocking on.
2. Intent drift: changes unrelated to the stated goal (a database change in
   UI work), scope creep, drive-by refactors mixed into features.
3. AI-isms and style: the Hard no list in ~/.claude/style/core.md, spurious
   comments, one-off helpers where shared ones exist, over-guarding,
   speculative abstraction.
4. Simplification: code that could disappear into an existing helper, the
   stdlib, or nothing.

Skip entirely: anything a linter or CI already catches, test coverage
sermons, praise, restating what the PR does.

## Report

The report's readability is the entire point. Format for a human scrolling a
terminal.

Lead with the verdict and one sentence of reasoning:

- mergeable: nothing worth holding it for.
- mergeable after nits: fine once the small stuff lands.
- needs work: at least one blocker or should-fix.

Then findings as one ranked list, worst first, blank line between entries.
Severity tag and file:line on the first line, explanation underneath:

    1. [blocker] src/auth/session.ts:84
       The refresh token is never invalidated on logout, so a stolen token
       stays valid until expiry.

    2. [should-fix] src/api/routes.ts:112
       500 responses include the internal error message, leaking stack
       details to the client.

    3. [nit] src/utils/time.ts:9
       Duplicates the existing formatDuration helper.

- Explanations are 1-2 complete sentences stating the concrete failure. No
  fragments, no arrow chains, no jargon shorthand.
- Include a short code excerpt only when the bug is invisible without it.
- No tables, no per-category sections, no finding counts, no closing summary.

Zero findings is a valid report; do not invent nits to look thorough. Mark
uncertain findings as such instead of asserting them.
