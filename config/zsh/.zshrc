# Load custom prompt
autoload -Uz vcs_info
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "%F{red}(%b) "

# Open the tmux session launcher if not in a tmux session
precmd() {
	if [[ -z $TMUX ]]; then
		"$dd/config/tui/tmux_launch.sh"
	else
		vcs_info
	fi
}

# Show the username and hostname on SSH connections
[[ $SSH_CONNECTION ]] && local user_host="%F{green}%n@%m%f "

setopt prompt_subst
PROMPT='${user_host}%F{cyan}%~%f ${vcs_info_msg_0_}%f➜ '

source "$DOTDIR/config/zsh/lscolors.zsh"

setopt append_history
setopt interactive_comments
setopt complete_in_word
setopt prompt_subst
setopt globdots
setopt cd_silent

source "$HOME/.cargo/env" # Rust environment
bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history

zstyle ":completion:*" use-cache on
zstyle ":completion:*" menu select
zstyle ":completion:*" completer _extensions _complete _approximate
zstyle ":completion:*" file-list list=20
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

if [[ "$OS" == "Darwin" ]]; then # Different cache path for macOS
	zstyle ":completion:*" cache-path "$HOME/Library/Caches/zsh/.zcompcache"
else
	zstyle ":completion:*" cache-path "$HOME/.cache/zsh/.zcompcache"
fi

launch() {
	if [[ -z $TMUX ]]; then
		"$dd/config/tui/tmux_launch.sh"
	else
		tmux popup -EE -w 60% -h 60% "$dd/config/tui/tmux_launch.sh"
	fi
}

# Platform specific configuration
if [[ "$OS" == "Darwin" ]]; then
	source "$DOTDIR/config/zsh/macos.zsh"
	
	[[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && COMPINIT_STAT=$(/usr/bin/stat -f "%Sm" -t "%j" ${ZDOTDIR:-$HOME}/.zcompdump)
else
	source "$DOTDIR/config/zsh/linux.zsh"
	[[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && COMPINIT_STAT=$(/usr/bin/stat -c "%Y" ${ZDOTDIR:-$HOME}/.zcompdump | date +"%j")
fi

# Load completions and suggestions at the end
fpath+=($DOTDIR/vendor/zsh-completions/src)
fpath+=($DOTDIR/config/zsh/completions)
autoload -Uz compinit

if [ $(date +"%j") != $COMPINIT_STAT ]; then
	compinit
else
	compinit -C
fi

# Helper function to maintain dotfiles
dotfiles() {
	case "$1" in
		"source")
			source "$ZDOTDIR/.zlogin"
			source "$ZDOTDIR/.zshrc"
			source "$HOME/.zshenv"
			;;
		"update")
			command git -C "$DOTDIR" stash
			command git -C "$DOTDIR" pull
			command git -C "$DOTDIR" stash pop

			source "$ZDOTDIR/.zlogin"
			source "$ZDOTDIR/.zshrc"
			source "$HOME/.zshenv"
			;;
		"reset")
			command git -C "$DOTDIR" reset --hard
			command git -C "$DOTDIR" clean -fd
			;;
		"bundle")
			command brew bundle dump --force --file="$DOTDIR/Brewfile"
			;;
		*)
			echo "Usage: dotfiles <source|update|reset|bundle>"
			;;
	esac
}

