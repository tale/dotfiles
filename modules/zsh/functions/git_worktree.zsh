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

local hash=$(printf '%s' "$branch" | shasum -a 256 | cut -c1-7)
local dir="${main_root:h}/${main_root:t}-${hash}"

if [[ -d "$dir" ]]; then
	rex do sessionizer "cwd=${dir:A}" > /dev/null
	return
fi

if git show-ref --verify --quiet "refs/heads/$branch"; then
	git worktree add "$dir" "$branch" || return 1
elif (( new )); then
	git fetch origin main || return 1
	git worktree add -b "$branch" "$dir" origin/main || return 1
else
	if ! git fetch origin "$branch"; then
		echo "Branch $branch not found locally or on origin (use -n to create it)"
		return 1
	fi
	git worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1
fi

rex do sessionizer "cwd=${dir:A}" > /dev/null
