# Set our prompt and command to return to our tmux harness if we are not in one
export PS1="\[\033[36m\]\w\[\033[31m\]\$(__git_ps1) \[\033[37m\]➜ \[\033[00m\]"
export PROMPT_COMMAND="[[ -z \$TMUX ]] && \$DOTDIR/config/bash/sessionize.sh || true;"
source "$DOTDIR/config/bash/ls_colors.bash" # LS_COLORS

shopt -s histappend # Append to history instead of overwriting
shopt -s cmdhist # Save multiline commands as one entry

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTFILE="$HOME/.local/state/.bash_history"

# Aliases and functions
alias g="git"
alias t="task"
alias p="pnpm"
alias c="cargo"
alias d="docker"
alias k="kubectl"

alias ls="ls --color=auto -lah"
alias grep="grep --color=auto"

alias nano="nvim"
alias vim="nvim"
alias htop="btop" # TODO: No?

alias mk="minikube"
alias mkmk="minikube start --driver=docker --kubernetes-version=v1.28.0"
alias nix-rebuild="darwin-rebuild switch --flake $DOTDIR"

launch() {
	if [[ -z $TMUX ]]; then
		"$DOTDIR/config/bash/sessionize.sh"
	else
		tmux popup -EE -w 60% -h 60% "$DOTDIR/config/bash/sessionize.sh"
	fi
}

function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}

# Use fzf for history search (Ctrl-R)
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history';

__fzf_history () {
	entry=$(history | fzf --tac --tiebreak=index | perl -ne 'm/^\s*([0-9]+)/ and print "!$1"')
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
