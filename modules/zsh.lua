local rb = require("rootbeer")
local zsh = require("rootbeer.zsh")

local is_mac = rb.host.os == "macos"

-- Environment
local env = {
  EDITOR = "nvim",
  VISUAL = "$EDITOR",
  OS = "$(uname -s)",
  RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/rc",
}

if is_mac then
  env.SSH_AUTH_SOCK = "$HOME/.config/1Password/agent.sock"
end

-- Login profile (.zprofile)
local login = nil
if is_mac then
  local sources = {}
  if rb.path_exists("~/.orbstack/shell/init.zsh") then
    table.insert(sources, "$HOME/.orbstack/shell/init.zsh")
  end

  login = {
    evals = { "/opt/homebrew/bin/brew shellenv" },
    sources = sources,
    path_prepend = {
      "$HOME/.amp/bin",
      "$HOME/.rootbeer/bin",
      "$HOME/.local/bin",
    },
  }
end

-- Variables
local variables = {}
if is_mac then
  variables.d = "$HOME/code"
end

-- Functions
local functions = {
  __fzf_history = [=[
local sel=$(fc -rl 1 | fzf --tiebreak=index --height=50%)
if [[ -n $sel ]]; then
	sel=$(echo $sel | sed -E 's/^[[:space:]]*[0-9]+[*+]?[[:space:]]+//')
	LBUFFER=$sel
fi
zle redisplay]=],

  git_rebase_upstream = [=[
local base
if [[ -n "$1" ]]; then
	base="$1"
else
	base=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null)
fi

if [[ -z "$base" ]]; then
	echo "No PR found and no base specified, falling back to 'main'"
	base="main"
fi

echo "Rebasing onto origin/$base..."
git fetch origin "$base"
git rebase --committer-date-is-author-date "origin/$base"
]=],

  git_stack_new = [=[
local new_branch="${1:?Usage: git-stack-new <new-branch> [base|pr/<number>]}"
local base_arg="$2"
local base

if [[ -z "$base_arg" ]]; then
	base=$(gh pr view --json headRefName -q .headRefName 2>/dev/null)
	if [[ -z "$base" ]]; then
		base=$(git branch --show-current)
	fi
elif [[ "$base_arg" == pr/* ]]; then
	local pr_number="${base_arg#pr/}"
	base=$(gh pr view "$pr_number" --json headRefName -q .headRefName)
else
	base="$base_arg"
fi

echo "Stacking onto $base"
git fetch origin "$base"
git checkout "origin/$base" -b "$new_branch"
]=],
}

if is_mac then
  functions.plsdns = [[
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder]]
end

zsh.config({
  env = env,
  profile = login,
  keybind_mode = "emacs",
  options = { "CORRECT", "EXTENDED_GLOB" },
  vcs_info = true,
  variables = variables,
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
    -- withenv = "env $(grep -v '^#' .env | xargs) ",
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
  widgets = { "__fzf_history" },
  keybindings = {
    ["^R"] = "__fzf_history",
  },
  evals = {
    "mise activate zsh",
  },
})
