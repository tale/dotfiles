shopt -s dotglob # Include dotfiles in globbing
shopt -s cdspell # Correct spelling errors in cd

export EDITOR="nvim"
export OS="Darwin"

export DOTDIR="$HOME/.config/dotfiles"
export LESSHISTFILE="$HOME/.local/state/.less_history"
export THEOS="$HOME/Library/Theos"
export d="$HOME/Developer"
export dd="$DOTDIR"

# Load Homebrew and Nix paths
# eval $(/opt/homebrew/bin/brew shellenv)
# if test -e /etc/static/bashrc; then
# 	. /etc/static/bashrc
# fi

launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
launchctl setenv PATH "$PATH"

