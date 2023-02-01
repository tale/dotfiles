# Instantly load Pure Prompt
fpath+=($DOTDIR/vendor/pure)
autoload -U promptinit; promptinit

zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:environment:nix-shell show no
zstyle :prompt:pure:path color cyan
zstyle :prompt:pure:prompt:success color 242

prompt pure

source "$DOTDIR/vendor/lscolors/lscolors.sh"

zstyle ":completion:*" use-cache on
zstyle ":completion:*" menu select
zstyle ":completion:*" file-list all
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" completer _extensions _complete _approximate

if [[ "$OS" == "Darwin" ]]; then # Different cache path for macOS
	zstyle ":completion:*" cache-path "$HOME/Library/Caches/zsh/.zcompcache"
else
	zstyle ":completion:*" cache-path "$HOME/.cache/zsh/.zcompcache"
fi

# Random Globals
export FZF_DEFAULT_COMMAND="fd --type f"
export BAT_THEME="TwoDark"

# Laziness
export dd="$DOTDIR"

# Aliases
alias g="git"
alias t="task"
alias p="pnpm"
alias c="cargo"
alias cat="bat"
alias d="docker"
alias k="kubectl"
alias find="fd"

alias l="exa -l"
alias la="exa -la"
alias ll="exa -lah"
alias ls="exa -l"

alias f="fzf"
alias nano="vi"
alias vi="nvim"
alias vim="nvim"

alias mk="minikube"
alias devc="devcontainer"
alias mkmk="minikube start --driver=docker --kubernetes-version=v1.25.0"

# Platform specific configuration
if [[ "$OS" == "Darwin" ]]; then
	source "$DOTDIR/config/zsh/macos.zsh"
fi

if [[ "$OS" == "Linux" ]]; then
	source "$DOTDIR/config/zsh/linux.zsh"
fi

# Load completions and suggestions at the end
fpath+=($DOTDIR/vendor/zsh-completions/src)
autoload -Uz compinit
if [ $(date +"%j") != $(/usr/bin/stat -f "%Sm" -t "%j" ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
	compinit
else
	compinit -C
fi

source "$DOTDIR/VENDOR/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Helper functions for managing dotfiles
dotsource() {
	source "$ZDOTDIR/.zlogin"
	source "$ZDOTDIR/.zshrc"
	source "$HOME/.zshenv"
}

dotdate() {
	command git -C "$DOTDIR" stash
	command git -C "$DOTDIR" pull
	command git -C "$DOTDIR" stash pop

	source "$ZDOTDIR/.zlogin"
	source "$ZDOTDIR/.zshrc"
	source "$HOME/.zshenv"
}
