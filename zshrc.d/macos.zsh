export THEOS="$HOME/Library/Theos"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1

# Brew path for manual linking overrides
export PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"

# Golang environment
export GOPATH=$HOME/go
export GOROOT="$HOMEBREW_PREFIX/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Bun enviroment
[ -s "/Users/tale/.bun/_bun" ] && source "/Users/tale/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Cheating lowercase Developer folder shortcut
export d="$HOME/Developer"

# iTerm2 Integrations
if [[ $LC_TERMINAL == "iTerm2" ]]; then
	source "$HOME/.extra/iterm.zsh"
fi

function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}
