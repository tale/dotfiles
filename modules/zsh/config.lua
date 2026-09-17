local rb = require("rootbeer")
local zsh = require("rootbeer.zsh")

local is_mac = rb.host.os == "macos"
local package_env = rb.env_export("sh")
local package_bin = rb.bin_dir()

local function fn(name)
  return rb.read_file("modules/zsh/functions/" .. name .. ".zsh")
end

local function secret(name)
  return rb.secret.age("private/" .. name .. ".age", {
    identity = "~/.config/sops/age/keys.txt",
  })
end

local functions = {
  __rootbeer_path = string.format([[
local package_bin=%q
path=("$package_bin" "${(@)path:#$package_bin}")
]], package_bin),
  __fzf_history = fn("__fzf_history"),
  __session_open = secret("alpha-open.zsh"),
  __sessionizer = secret("alpha-sessionizer.zsh"),
  git_worktree = fn("git_worktree"),
}

if is_mac then
  functions.plsdns = fn("plsdns")
end

zsh.config({
  env = {
    EDITOR = "nvim",
    VISUAL = "$EDITOR",
    OS = "$(uname -s)",
    OP_BIOMETRIC_UNLOCK_ENABLED = is_mac and "true" or nil,
    PATH = is_mac and secret("alpha-path") or nil,
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
      package_bin,
    },
  } or nil,
  sources = { package_env },
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
    gl = "git log --oneline --graph --decorate --all",
    gm = "git merge",
    gp = "git pull",
    gpfh = "git push --force-with-lease origin HEAD",
    gpoh = "git push origin HEAD",
    gr = "git restore",
    gredo = "git commit --amend -S",
    gs = "git status",
    gsi = "gh stack init",
    gsn = "gh stack add",
    gss = "gh stack submit",
    gsu = "gh stack rebase --no-trunk",
    gsU = "gh stack rebase",
    gsv = "gh stack view",
    gsw = "gh stack switch",
    gwt = "git_worktree",
    gwtn = "git_worktree -n",
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
    "__sessionizer",
  },
  keybindings = {
    ["^R"] = "__fzf_history",
    ["^F"] = "__sessionizer",
  },
  evals = {
    rb.bin_path("mise") .. " activate zsh",
  },
  extra = {
    "add-zsh-hook precmd __rootbeer_path",
    "add-zsh-hook chpwd __rootbeer_path",
    "__rootbeer_path",
  },
})
