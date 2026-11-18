(( $+commands[rex] )) || { print -u2 'rex is not installed'; return 1; }

local dir id
dir=$("$HOME/.local/bin/git-worktree" "$@") || return

id=$(rex do sessionizer "cwd=$dir" --json | jq -r .session_id)
rex do session.select session_id="$id" > /dev/null
