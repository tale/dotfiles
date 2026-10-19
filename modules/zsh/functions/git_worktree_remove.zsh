if (( $# )); then
  print -u2 'Usage: gwtr (from inside a worktree)'
  return 1
fi
(( $+commands[rex] )) || { print -u2 'rex is not installed'; return 1; }
(( $+commands[jq] )) || { print -u2 'jq is not installed'; return 1; }

local dir main_root worktrees
dir=$(git rev-parse --show-toplevel) || return
worktrees=$(git worktree list --porcelain -z) || return
main_root=${${worktrees%%$'\0'*}#worktree }
if [[ "${dir:A}" == "${main_root:A}" ]]; then
  print -u2 'Refusing to remove the primary checkout'
  return 1
fi

local label=$dir
[[ "$label" == "$HOME/code/gh/"* ]] && label=${label#"$HOME/code/gh/"}
[[ "${label:t}" == *@* ]] && label="${label%@*} [${label##*@}]"

local listing matches
listing=$(rex ls --json) || return
matches=$(print -r -- "$listing" | jq -er --arg label "$label" '
  [.sessions[] | select(.label == $label) | .session_id] | join("\n")
') || return
local -a sessions=(${(f)matches})

local previous_dir=$PWD
builtin cd "$main_root" || return
if ! git worktree remove "$dir"; then
  builtin cd "$previous_dir"
  return 1
fi

print -r -- "Removed $dir (branch kept)"
(( ${#sessions} )) || return 0

# Close the caller last so its terminal survives the other closures.
sessions=("${(@)sessions:#${REX_SESSION:-}}" "${(@M)sessions:#${REX_SESSION:-}}")
rex kill "${sessions[@]}"
