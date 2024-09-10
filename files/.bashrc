shopt -s dotglob  # Include dotfiles in globbing
shopt -s cdspell  # Correct spelling errors in cd
shopt -s cmdhist  # Save multiline commands as one entry
shopt -s extglob  # Enable extended globbing
shopt -s globstar # Enable ** for recursive globbing

export EDITOR="nvim"
export OS=$(uname -s)

if [ $OS = "Darwin" ]; then
	export SSH_AUTH_SOCK="$HOME/.config/1Password/agent.sock"
	export d="$HOME/Developer"

	eval $(/opt/homebrew/bin/brew shellenv)
    for bindir in "${HOMEBREW_PREFIX}/opt/"*"/libexec/gnubin"; do
		export PATH=$bindir:$PATH;
	done

    for mandir in "${HOMEBREW_PREFIX}/opt/"*"/libexec/gnuman"; do
		export MANPATH=$mandir:$MANPATH;
	done

	export PNPM_HOME="$HOME/Library/pnpm"
	export PATH="$(go env GOPATH)/bin:$PNPM_HOME:$PATH"
	source "$HOME/.cargo/env"

	launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
	launchctl setenv PATH "$PATH"
else
	source "/etc/bashrc"
fi

# Interactive stuff below
[[ $- == *i* ]] || return

export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTFILE="$HOME/.local/state/.bash_history"
export HISTCONTROL="ignoredups:erasedups"

shopt -s histappend
shopt -s checkwinsize
shopt -s checkjobs

export PS1="\[\033[36m\]\w\[\033[31m\]\$(__git_ps1) \[\033[37m\]> \[\033[00m\]"
export PROMPT_COMMAND=__prompt_command

__prompt_command() {
	history -a;
	history -c;
	history -r;
	if [ $OS = "Darwin" ]; then
		[[ -z $TMUX ]] && $HOME/.config/bash/sessionize.sh || true;
	fi
}

if [ $OS = "Darwin" ]; then
	source "/opt/homebrew/etc/bash_completion.d/git-prompt.sh"

	function plsdns() {
		command sudo dscacheutil -flushcache
		command sudo killall -HUP mDNSResponder
	}
else
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

# Aliases and functions
alias g="git"
alias b="brew"
alias t="task"
alias p="pnpm"
alias d="docker"
alias k="kubectl"

alias la="ls --color=auto -lLah"
alias ls="ls --color=auto -Lh"
alias grep="grep --color=auto"

alias vim="nvim"
alias vi="nvim"

# Use fzf for history search (Ctrl-R)
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __history';

__history() {
	history -a;
    history -c;
    history -r;
	e=$(history | fzf --tac --tiebreak=index | cut -d' ' -f2- | awk '{$1=$1};1')
	if [[ -n $e ]]; then
		bind '"\er": redraw-current-line'
		bind '"\e^": magic-space'
		READLINE_LINE="$e"
		READLINE_POINT=${#e}
	else
		bind '"\er":'
		bind '"\e^":'
	fi
}
