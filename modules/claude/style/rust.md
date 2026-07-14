# Rust

- `?` propagation everywhere; `Ok(...)` tail expressions; early-return guards
  (`if specs.is_empty() { return Ok(Vec::new()); }`).
- No `unwrap()` in library/runtime code; `expect("descriptive message")` only
  in tests and `build.rs`.
- Errors: `anyhow` for application/CLI code (reported, not matched). Library
  surfaces get typed enums with named-field variants and cheap context
  (`&'static str`), messages polished for the end user. [work] Match the
  SDK's existing shape: derive-based, `#[non_exhaustive]`, struct variants.
- Named-file modules (`foo.rs`, split into `foo/` when it grows). `mod ...;`
  then `pub use` re-exports as the public surface; `pub(crate)` for
  internals. Visibility is deliberate.
- Compact ordered derives: `#[derive(Debug, Clone, Copy, PartialEq, Eq)]`;
  `#[default]` on the default variant.
- `match` with `Self::` arms; `if let` / `let ... else` for single branches;
  exhaustive matches on named-field op enums
  (`Op::WriteFile { path, source }`).
- Traits for extension points; typestate flows (`plan(self) -> Planned`, then
  `.execute()`); `impl Trait` in argument position. `#[must_use]` on
  pure/builder-style public fns.
- Synchronous unless async is genuinely required.
- `.to_owned()` for `&str` to `String` [work]. `env!()` for compile-time
  constants.
- Rustdoc 1-3 lines on public items: rationale and edge cases, identifiers
  backticked. clap derive doc comments double as `--help` text.
- `#[allow]` always carries `reason = "..."`. Tests in dedicated
  modules/files, not inline sprawl.
