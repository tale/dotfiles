#!/usr/bin/env zsh

# Check if $d is set and is a directory
if [[ -z $d || ! -d $d ]]; then
	echo "Developer directory ($d) is not set correctly"
	exit 1
fi

# Open the fzf menu in the developer directory
dir=$(fd -d 2 -t d . $d | fzf --ansi --preview 'et --icons {}')
if [[ -z $dir ]]; then
	exit 0
fi

# Create a new tmux window in the directory
tmux new-window -c "$dir"
