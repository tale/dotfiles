export THEOS="$HOME/Library/Theos"
export HOMEBREW_NO_AUTO_UPDATE=1

# Better than brew --prefix because it isn't slow
if [[ $CPUTYPE == "x86_64" ]];
then
	export BREW_PREFIX="/usr/local"
else
	export BREW_PREFIX="/opt/homebrew"
fi

# Brew path for manual linking overrides
export PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$BREW_PREFIX/opt/ruby/bin:$PATH"

# iTerm2 Integrations
if [[ $LC_TERMINAL == "iTerm2" ]]; then
	source "$HOME/.extra/iterm.zsh"
fi

function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}
