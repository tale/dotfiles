(( $+commands[rex] )) || { print -u2 'rex is not installed'; return 1; }

local dir
dir=$("$HOME/.local/bin/git-worktree" "$@") || return

rex do sessionizer "cwd=$dir" > /dev/null
