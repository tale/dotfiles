shopt -s dotglob # Include dotfiles in globbing
shopt -s cdspell # Correct spelling errors in cd
shopt -s histappend # Append to history instead of overwriting
shopt -s cmdhist # Save multiline commands as one entry

export EDITOR="nvim"
export OS="Darwin"

export DOTDIR="$HOME/Developer/personal/dotfiles"
export LESSHISTFILE="$HOME/.local/state/.less_history"
export d="$HOME/Developer"
export dd="$DOTDIR"

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTFILE="$HOME/.local/state/.bash_history"
export HISTIGNORE="history -r:history -a"

eval $(/opt/homebrew/bin/brew shellenv)
launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
launchctl setenv PATH "$PATH"

