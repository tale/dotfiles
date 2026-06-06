local rb = require("rootbeer")
local zsh = require("rootbeer.zsh")

local is_mac = rb.host.os == "macos"

local function fn(name)
  return rb.read_file("modules/zsh/functions/" .. name .. ".zsh")
end

local functions = {
  __fzf_history = fn("__fzf_history"),
  __ghostty_sessionizer = fn("__ghostty_sessionizer"),
  git_rebase_upstream = fn("git_rebase_upstream"),
  git_stack_new = fn("git_stack_new"),
}

if is_mac then
  functions.plsdns = fn("plsdns")
end

zsh.config({
  env = {
    EDITOR = "nvim",
    VISUAL = "$EDITOR",
    OS = "$(uname -s)",
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/rc",
    SSH_AUTH_SOCK = is_mac and "$HOME/.config/1Password/agent.sock" or nil,
  },
  profile = is_mac and {
    evals = { "/opt/homebrew/bin/brew shellenv" },
    sources = rb.path_exists("~/.orbstack/shell/init.zsh") and {
      "$HOME/.orbstack/shell/init.zsh",
    } or {},
    path_prepend = {
      "$HOME/.amp/bin",
      "$HOME/.rootbeer/bin",
      "$HOME/.local/bin",
    },
  } or nil,
  keybind_mode = "emacs",
  options = { "CORRECT", "EXTENDED_GLOB" },
  variables = is_mac and { d = "$HOME/code" } or {},
  -- vcs_info without check-for-changes: branch + rebase/merge state still
  -- render, but we skip the per-prompt `git diff-index` + `git ls-files -o`
  -- that kills perf on huge worktrees. We weren't showing %c/%u anyway.
  vcs_info = { check_for_changes = false },
  prompt = "%F{cyan}%~%f%F{red}${vcs_info_msg_0_}%f %F{white}>%f ",
  aliases = {
    b = "brew",
    d = "docker",
    g = "git",
    ga = "git add -p",
    gad = "git add",
    gb = "git branch",
    gc = "git commit",
    gco = "git checkout",
    gd = "git diff",
    gdc = "git diff --cached",
    gf = "git fetch",
    gm = "git merge",
    gp = "git pull",
    gpoh = "git push origin HEAD",
    gr = "git restore",
    gredo = "git commit --amend -S",
    gs = "git status",
    gsn = "git_stack_new",
    gsu = "git_rebase_upstream",
    k = "kubectl",
    la = "lsd -la --group-directories-first",
    ls = "lsd -l --group-directories-first",
    p = "pnpm",
    vim = "nvim",
    y = "yarn",
  },
  history = {
    size = 10000,
    ignore = "ls*",
  },
  completions = {
    vi_nav = true,
    cache = "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache",
    styles = {
      [":completion:*"] = "completer _complete _approximate",
      [":completion:*:menu"] = "select=long-list",
      [":completion:*:*:*:*:descriptions"] = "format '%F{green}--> %d%f'",
      [":completion:*:*:*:*:corrections"] = "format '%F{yellow}!-> %d (errors: %e)%f'",
      [":completion:*:messages"] = "format ' %F{purple}--> %d%f'",
      [":completion:*:warnings"] = "format ' %F{red}!-> no matches found%f'",
      [":completion:*:group-name"] = "''",
      [":completion:*:*:-command-:*:*"] = "group-order alias builtins functions commands",
      [":completion:*:file-list"] = "all",
      [":completion:*:default"] = "list-colors ${(s.:.)LS_COLORS}",
      [":completion:*:squeeze-slashes"] = "true",
    },
  },
  functions = functions,
  widgets = {
    "__fzf_history",
    "__ghostty_sessionizer",
  },
  keybindings = {
    ["^R"] = "__fzf_history",
    ["^F"] = "__ghostty_sessionizer",
  },
  evals = {
    "mise activate zsh",
  },
})
