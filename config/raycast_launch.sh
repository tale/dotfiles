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

# disable all output
exec 1> /dev/null

source ~/.zshenv &> /dev/null
source "$ZDOTDIR/.zshrc" &> /dev/null
command /Applications/Neovim.app/Contents/MacOS/nvim-qt --maximized $(eval echo "$1") &> /dev/null
