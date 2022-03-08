export DOTDIR="$HOME/.dotfiles"

# Load zinit
source "$DOTDIR/vendor/zinit/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

source "$DOTDIR/zshrc.d/dotfunctions.zsh"

# Random Globals
export FZF_DEFAULT_COMMAND='fd --type f'
export BAT_THEME="TwoDark"

# Aliases
alias g='git'
alias t='task'
alias p='pnpm'
alias cat='bat'
alias d='docker'
alias k='kubectl'
alias find='fd'

alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'

alias f='fzf'
alias c='clear'
alias nano='vi'
alias vi='nvim'
alias vim='nvim'

# Platform specific configuration
if [[ $(uname -s) == "Darwin" ]]; then
	source "$DOTDIR/zshrc.d/macos.zsh"
fi

if [[ $(uname -s) == "Linux" ]]; then
	source "$DOTDIR/zshrc.d/linux.zsh"
fi
