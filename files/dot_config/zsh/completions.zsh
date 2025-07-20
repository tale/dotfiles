zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -Uz compinit; compinit
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' menu select=long-list
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}--> %d%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!-> %d (errors: %e)%f'
zstyle ':completion:*:messages' format ' %F{purple}--> %d%f'
zstyle ':completion:*:warnings' format ' %F{red}!-> no matches found%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
zstyle ':completion:*' file-list all
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
