# C

- C17 strict with POSIX feature-test macros; no compiler extensions.
- snake_case throughout. `_t`-suffixed typedef structs (`term_t`). UPPERCASE
  macros (`MAX_BATCH 65536`). Fixed-width integer types (`uint16_t`).
- `<verb>_<noun>` functions, one operation per file under the noun's
  directory: `src/term/{init,destroy,render,resize,handle}.c` gives
  `init_term`, `render_term`, and so on.
- `int` returns, `1` success / `0` failure; callers guard and log:
  `if (!init_term(&state, &config)) { log_error("..."); return -1; }`
- Allocation: `p = malloc(sizeof *p)`; `calloc` for zeroed. Immediate `NULL`
  check, `log_error`, and failure return on every allocation.
  `create`/`destroy` pairs for heap objects; stack structs passed by pointer;
  explicit `destroy_*` cleanup, no `goto` chains.
- Bounded string ops: `snprintf` and explicit lengths, never bare
  `strcpy`/`strcat`.
- Anonymous nested structs group related state (`gl_state`, `states`).
- Headers: uppercase `#ifndef NAME_H` guards; project includes quoted and
  alphabetized, then system includes angled; platform splits via
  `#ifdef __APPLE__`.
