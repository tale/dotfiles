(( $+commands[rex] )) || { print -u2 'rex is not installed'; return 1; }

local new=0
if [[ "$1" == "-n" ]]; then
	new=1
	shift
fi
local branch="${1:?Usage: git-worktree [-n] <branch>}"

local main_root
main_root=$(git worktree list --porcelain | head -1 | cut -d' ' -f2-)
if [[ -z "$main_root" ]]; then
	echo "Not in a git repository"
	return 1
fi

local default=$(git -C "$main_root" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
default="${${default#origin/}:-main}"

# The main checkout always holds the default branch; work happens in worktrees.
local dir="${main_root}@${branch//\//-}"
[[ "$branch" == "$default" ]] && dir="$main_root"

if [[ -d "$dir" ]]; then
	rex do sessionizer "cwd=${dir:A}" > /dev/null
	return
fi

if git show-ref --verify --quiet "refs/heads/$branch"; then
	git worktree add "$dir" "$branch" || return 1
elif (( new )); then
	git fetch origin "$default" || return 1
	git worktree add -b "$branch" "$dir" "origin/$default" || return 1
else
	if ! git fetch origin "$branch"; then
		echo "Branch $branch not found locally or on origin (use -n to create it)"
		return 1
	fi
	git worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1
fi

rex do sessionizer "cwd=${dir:A}" > /dev/null
