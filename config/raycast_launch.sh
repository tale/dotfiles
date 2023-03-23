#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title code CLI
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻
# @raycast.argument1 { "type": "text", "placeholder": "path" }

# Documentation:
# @raycast.description Open a file/directory in Visual Studio Code
# @raycast.author Aarnav Tale
# @raycast.authorURL https://aarnavtale.com

exec 1>/dev/null 2>&1
source ~/.zshenv &> /dev/null
source "$ZDOTDIR/.zshrc" &> /dev/null

ARGUMENT=$(eval echo "$1")
command open -a Alacritty --args -e /opt/homebrew/bin/zsh -c "nvim $ARGUMENT" &> /dev/null 
