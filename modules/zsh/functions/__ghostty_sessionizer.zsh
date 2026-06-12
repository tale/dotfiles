emulate -L zsh
local ROOT_DIR="$HOME/code/gh"
[ -d "$ROOT_DIR" ] || return 0

local -a paths
paths=("${(@f)$(
	find "$ROOT_DIR" -maxdepth 3 -name .git -prune 2>/dev/null \
	| sed 's:/\.git$::' | sort -u
)}")
[[ -n "$paths" ]] || return 0

local -a names branches
local repo maxlen=0
for repo in "${paths[@]}"; do
	local name="${repo#"$ROOT_DIR"/}" branch=""
	if [[ -f "$repo/.git" ]]; then
		local gitdir=$(<"$repo/.git")
		gitdir="${gitdir#gitdir: }"
		[[ "$gitdir" = /* ]] || gitdir="$repo/$gitdir"
		if [[ -r "$gitdir/HEAD" ]]; then
			local head_ref=$(<"$gitdir/HEAD")
			[[ "$head_ref" = ref:\ refs/heads/* ]] && branch="${head_ref#ref: refs/heads/}"
		fi
	fi
	names+=("$name")
	branches+=("$branch")
	(( ${#name} > maxlen )) && maxlen=${#name}
done

local i
local selected=$(
	for (( i = 1; i <= ${#paths}; i++ )); do
		if [[ -n "${branches[i]}" ]]; then
			printf '%-*s  [%s]\t%s\n' "$maxlen" "${names[i]}" "${branches[i]}" "${paths[i]}"
		else
			printf '%s\t%s\n' "${names[i]}" "${paths[i]}"
		fi
	done \
	| fzf --delimiter='\t' --with-nth=1 --accept-nth=2 --prompt='project ❯ '
) || return 0
[ -n "$selected" ] || return 0

__ghostty_open "$selected"
