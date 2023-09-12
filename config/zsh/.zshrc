# Load custom prompt
autoload -Uz vcs_info
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "%F{red}(%b) "

# Handles a case where macOS updates and removes the source to /etc/static/zshrc
if test -e /etc/static/zshrc; then
	. /etc/static/zshrc;
fi

# Register the tmux launch command
launch() {
	if [[ -z $TMUX ]]; then
		"$dd/config/tui/tmux_launch.sh"
	else
		tmux popup -EE -w 60% -h 60% "$dd/config/tui/tmux_launch.sh"
	fi
}

setopt prompt_subst
PROMPT='%F{cyan}%~%f ${vcs_info_msg_0_}%f➜ '

# Useful shell options
setopt append_history
setopt share_history
setopt interactive_comments
setopt complete_in_word
setopt prompt_subst
setopt globdots
setopt cd_silent

source "$DOTDIR/config/zsh/lscolors.zsh" # LS_COLORS
eval $(/opt/homebrew/bin/brew shellenv) # Homebrew

# Completion Styling
zstyle ":completion:*" use-cache on
zstyle ":completion:*" menu select
zstyle ":completion:*" completer _extensions _complete _approximate
zstyle ":completion:*" file-list list=20
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# On macOS ~/Library/Caches is the recommended location for caches
zstyle ":completion:*" cache-path "$HOME/Library/Caches/zsh/.zcompcache"

# Inject the SSH authentication socket into launchd
command launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
command launchctl setenv PATH "$PATH"

# Workaround a dumb DNS cache lifetime issue
function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}

# Open the tmux session launcher if not in a tmux session
precmd() {
	if [[ -z $TMUX ]]; then
		"$dd/config/tui/tmux_launch.sh"
	else
		vcs_info
	fi
}

if [[ -f $ZDOTDIR/.zcompdump ]]; then
	# Hardcoded to use BSD stat
	COMPINIT_STAT=$(/usr/bin/stat -f "%Sm" -t "%j" $ZDOTDIR/.zcompdump)
fi

autoload -Uz compinit
[ $(date +"%j") != $COMPINIT_STAT ] && compinit || compinit -C
