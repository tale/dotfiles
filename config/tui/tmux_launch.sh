#!/usr/bin/env zsh

# Check if $d is set and is a directory
if [[ -z $d || ! -d $d ]]; then
	echo "Developer directory ($d) is not set correctly"
	exit 1
fi

# Add an option for raw folders
dirs=$(fd -d 2 -t d . $d)
dirs="~\n$dirs\n$dd"

# Open the fzf menu in the developer directory
dir=$(echo $dirs | fzf --ansi \
	--border none \
	--no-scrollbar \
	--preview-window border-left:60% \
	--preview "exa --color=always -TD --git-ignore {}")
if [[ -z $dir ]]; then
	exit 0
fi

# Takes the directory and creates a session name from the last 2 parts
session_dir_prefix=$(basename "$(dirname "$dir")")
session_name="$session_dir_prefix-$(basename "$dir")"
tmux_running="$(pgrep tmux)"

# Custom session names
if [[ $dir == "~" ]]; then
	session_name="main"
	dir="$HOME"
fi

if [[ $dir == "$dd" ]]; then
	session_name="dotfiles"
	dir="$dd"
fi

# Tmux is not running, start the session here
if [[ -z $TMUX && -z $tmux_running ]]; then
	tmux new-session -s "$session_name" -c "$dir"
	exit 0
fi

# Tmux is running, check if the session exists
if ! tmux has-session -t "$session_name" 2>/dev/null; then
	# Session does not exist, create it
	tmux new-session -ds "$session_name" -c "$dir"
fi

# Attach to the session
tmux switch-client -t "$session_name"

