export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"
export THEOS="$HOME/Library/Theos"

# Configure brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1

# Brew path for manual linking overrides
export PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"

# JS environment
[ -s "/Users/tale/.bun/_bun" ] && source "/Users/tale/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Cheating lowercase Developer folder shortcut
export d="$HOME/Developer"

# Workaround a dumb DNS cache lifetime issue
function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}

function brewdump() {
	command brew bundle dump --force
}

# Start gpg-agent for SSH
export "GPG_TTY=$(tty)"
gpgconf --launch gpg-agent

# Configure completions
fpath+=($HOME/.bun)
fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)

command launchctl setenv PATH "$PATH"
command launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"

# If ALACRITTY_SOCKET is set, we are running in Alacritty
# Automatically attach to a tmux session in Alacritty
if [[ -n "$ALACRITTY_SOCKET" ]]; then
	if [[ -z "$TMUX" ]]; then
		launch
	fi
fi
