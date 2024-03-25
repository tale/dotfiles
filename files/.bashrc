shopt -s dotglob # Include dotfiles in globbing
shopt -s cdspell # Correct spelling errors in cd
shopt -s histappend # Append to history instead of overwriting
shopt -s cmdhist # Save multiline commands as one entry

export EDITOR="nvim"
export OS=$(uname -s)

if [ $OS = "Darwin" ]; then
	export SSH_AUTH_SOCK="$HOME/.config/1Password/agent.sock"
	export d="$HOME/Developer"
	. $HOME/.cargo/env

	eval $(/opt/homebrew/bin/brew shellenv)
    for bindir in "${HOMEBREW_PREFIX}/opt/"*"/libexec/gnubin"; do
		export PATH=$bindir:$PATH;
	done

    for mandir in "${HOMEBREW_PREFIX}/opt/"*"/libexec/gnuman"; do
		export MANPATH=$mandir:$MANPATH;
	done

	launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
	launchctl setenv PATH "$PATH"
else
	. /etc/bashrc
fi

# Interactive stuff below
[[ $- == *i* ]] || return

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTFILE="$HOME/.local/state/.bash_history"
export HISTIGNORE="history -r:history -a"

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

. $HOME/.config/bash/ls_colors.sh

export PS1="\[\033[36m\]\w\[\033[31m\]\$(__git_ps1) \[\033[37m\]➜ \[\033[00m\]"

if [ $OS = "Darwin" ]; then
	. "/opt/homebrew/etc/bash_completion.d/git-prompt.sh"
	export PROMPT_COMMAND="history -a; history -r; [[ -z \$TMUX ]] && \$HOME/.config/bash/sessionize.sh || true;"

	function plsdns() {
		command sudo dscacheutil -flushcache
		command sudo killall -HUP mDNSResponder
	}
else
	. "/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

# Aliases and functions
alias g="git"
alias t="task"
alias p="pnpm"
alias d="docker"
alias k="kubectl"

alias ls="ls --color=auto -lah"
alias grep="grep --color=auto"

alias vim="nvim"
alias vi="nvim"

# Use fzf for history search (Ctrl-R)
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history';

__fzf_history () {
	entry=$(history | fzf --tac --tiebreak=index | cut -d' ' -f2- | awk '{$1=$1};1')
	if [[ -n $entry ]]; then
		bind '"\er": redraw-current-line'
		bind '"\e^": magic-space'
		READLINE_LINE="$entry"
		READLINE_POINT=${#entry}
	else
		bind '"\er":'
		bind '"\e^":'
	fi
}

