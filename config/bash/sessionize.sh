#!/usr/bin/env bash
# Inspired by ThePrimeagen's tmux-sessionizer

sessions="$(tmux ls | awk -F: '{print $1}')"
dirs=$(find $d -maxdepth 2 -type d | sed "s|^$d|~|")
sel=$(printf "$sessions\n%s\n" "${dirs[@]}" | fzf)

if [[ -z $sel ]]; then
	exit 0
fi

dir="${sel//\~/$d}"
if [[ -d $dir ]]; then
	prefix=$(basename "$(dirname "$dir")")
	name=$(basename "$dir" | tr . -)

	session_name="$prefix-$name"
else
	session_name="$sel"
fi

if [[ -z $(pgrep tmux) ]] || ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$dir"
else
	if [[ -z $TMUX ]]; then
		tmux attach -t "$session_name"
	else
		tmux switch-client -t "$session_name"
	fi
fi

