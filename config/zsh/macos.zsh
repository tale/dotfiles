export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"
export THEOS="$HOME/Library/Theos"

# Configure brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"

# Workaround a dumb DNS cache lifetime issue
function plsdns() {
	command sudo dscacheutil -flushcache
	command sudo killall -HUP mDNSResponder
}

# Start gpg-agent for SSH
export "GPG_TTY=$(tty)"
gpgconf --launch gpg-agent

# Configure completions
fpath+=($HOME/.bun)
fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)

command launchctl setenv PATH "$PATH"
command launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
