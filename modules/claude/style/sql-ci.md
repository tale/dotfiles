# SQL (Postgres) + GitHub Actions

SQL [work]:

- UPPERCASE keywords, lowercase types, snake_case, schema-qualified, singular
  table names.
- Idempotent DDL: `IF NOT EXISTS` everywhere; `DO $$ ... $$` guards for
  constraints.
- `COMMENT ON` every table and column. RLS from day one: `REVOKE ALL`,
  column-scoped `GRANT`s, `ENABLE ROW LEVEL SECURITY`, org-isolation policy.
- PKs `DEFAULT uuidv7()` where available, else `gen_random_uuid()`.
  `timestamp with time zone DEFAULT now()`. Numbered triggers
  (`_100_modify_datetime`); `*_idx` index suffixes.

GitHub Actions:

- Actions pinned to full commit SHA with a trailing `# vX.Y.Z` comment.
- Least-privilege `permissions:` block per workflow: default-deny, grant what
  the job uses.
- `concurrency` with `cancel-in-progress` on PR-triggered workflows.
- Descriptive step names; keys alphabetized where order doesn't matter; crons
  get a human-readable timezone comment; WHY comments on non-obvious infra
  choices.
