# TypeScript / React

- Maximum compiler strictness, non-negotiable.
- No `any`. `unknown` at trust boundaries, then narrow with type guards. No
  `enum`: string-literal unions or `as const` objects.
- Casts only at deserialization boundaries (`JSON.parse(line) as T`); prefer
  `as unknown` when truly unknown. `!` needs a justifying comment [personal];
  avoid at [work].
- [work] `type` aliases exclusively, members alphabetized. [personal]
  `interface` for object shapes/Props, `type` for unions, options bags,
  derived types.
- Explicit return types on everything exported/public; [work] annotate
  essentially every function including hook callbacks.
- Discriminated-union results:
  `{ ok: true; value: T } | { ok: false; error: E }`; two-state feature types
  (`{ state: "enabled"; value } | { state: "disabled"; reason }`).
- `satisfies` for typed literals. Derive from source-of-truth types
  (`NonNullable<...>`, `inferRouterOutputs<...>`, `Parameters<typeof fn>`)
  instead of re-declaring. Template-literal types for constrained strings
  (`` path: `v1/${string}` ``).
- Boundary schemas with the repo's validation lib, chained expressively
  (`z.coerce.number().int().min(1).max(65_535).default(465)`).
- `== null` / `!= null` are the only loose comparisons; everything else
  `===`. `??`, `?.`, `.at(-1)`.
- `for...of` (with `.entries()` for the index) for side effects;
  `.map`/`.filter`/`.sort` for pure transforms; `.filter(Boolean)` to drop
  nulls.
- Prefer new stdlib over helpers: `structuredClone`, `Object.groupBy`,
  `toSorted`/`toSpliced`, subject to the browser support floor.
- `async`/`await` only, no `.then` chains. Regex literals carry `u`;
  `.replaceAll` over global `.replace`.
- ESM, `node:` prefixed builtins. Import groups: `node:` builtins, external
  packages, alias (`~/`, `@/`), relative. `import type` for types. Barrels
  only as a library's public surface.
- Logging via the repo's logger; lowercase, specific, domain-prefixed
  messages (`payouts: user ${user.username} has payouts withheld - skipping`).

React:

- `useMemo` only for expensive or referentially-sensitive derivations
  (complete dep arrays); trivial derivations inline. Hooks clustered at the
  top.
- Props destructured in the signature. [personal]
  `export default function Name({ ... }: Props)` with a local unexported
  `Props` interface; [work] named arrow-const exports.
- Conditional render: `x == null ? null : <JSX/>`; never `&&` falsy-render
  footguns.
- `className` via the repo's `cn()` helper; multi-line class lists as arrays.
  `key` on every mapped element. User-facing strings go through the repo's
  i18n, never hardcoded.
