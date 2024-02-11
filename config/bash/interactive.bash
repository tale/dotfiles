source "$DOTDIR/config/bash/ls_colors.bash" # LS_COLORS
export PS1="\[\033[36m\]\w\[\033[31m\]\$(__git_ps1) \[\033[37m\]➜ \[\033[00m\]"
export PROMPT_COMMAND="history -a; history -r; [[ -z \$TMUX ]] && \$DOTDIR/config/bash/sessionize.sh || true;"

# Aliases and functions
alias g="git"
alias t="task"
alias p="pnpm"
alias d="docker"
alias k="kubectl"

alias ls="ls --color=auto -lah"
alias grep="grep --color=auto"

alias vim="nvim"
alias nix-rebuild="darwin-rebuild switch --flake $DOTDIR"

launch() {
	if [[ -z $TMUX ]]; then
		"$DOTDIR/config/bash/sessionize.sh"
	else
		tmux popup -EE "$DOTDIR/config/bash/sessionize.sh"
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
