set -o emacs
setopt CORRECT
setopt EXTENDED_GLOB

autoload -Uz vcs_info
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats " (%b)"

precmd() {
	vcs_info
}

setopt prompt_subst
PS1='%F{cyan}%~%f%F{red}${vcs_info_msg_0_}%f %F{white}>%f '

if [ $OS = Darwin ]; then
	plsdns() {
		sudo dscacheutil -flushcache
		sudo killall -HUP mDNSResponder
	}

	d=$HOME/code
fi

alias g=git
alias b=brew
alias p=pnpm
alias d=docker
alias k=kubectl
alias vim=nvim

alias ls='eza -l'
alias la='eza -la'
alias grep='grep --color=auto'

# History stuff
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTIGNORE='ls*'

__fzf_history() {
	local sel=$(fc -rl 1 | fzf --tiebreak=index --height=50%)
	if [[ -n $sel ]]; then
		sel=$(echo $sel | sed -E 's/^[[:space:]]*[0-9]+[*+]?[[:space:]]+//')
		LBUFFER=$sel
	fi

	zle redisplay
}

zle -N __fzf_history
bindkey '^R' __fzf_history

eval "$(mise activate zsh)"
