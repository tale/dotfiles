#!/usr/bin/env bash
launchdload() {
	command launchctl unload $1
	command launchctl load $1
}

echo "Installing brew & formulae from Brewfile"
command curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
command brew tap homebrew/bundle
command brew bundle --no-lock --file "$DOTDIR/Brewfile"

# Post-brew installations
notify "Running post-brew configurations"
command curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm
command pnpm add -g pnpm # Upgrade pnpm after installation

command mkdir -p "$HOME/.gnupg" && rm -rf "$HOME/.gnupg/gpg-agent.conf" # Reconfigure gpg-agent.conf
echo -e "pinentry-program /usr/local/bin/pinentry-mac\nenable-ssh-support" >> "$HOME/.gnupg/gpg-agent.conf"

# Install iTerm2 Integrations
notify "Setting up iTerm Shell Integrations"
command mkdir -p "$HOME/.extra" && rm -rf "$HOME/.extra/iterm.zsh"
command curl -L https://iterm2.com/shell_integration/zsh -o "$HOME/.extra/iterm.zsh"

# Install and Configure Theos
notify "Installing Theos"
THEOS="$HOME/Library/Theos"
if [[ ! -d $THEOS ]];
then
	command git clone --recursive https://github.com/theos/theos.git $THEOS
else
	echo "$THEOS already exists. Not cloning again."
fi

command rm -rf "$HOME/.theosrc"
command ln -s "$DOTDIR/.theosrc" "$HOME/.theosrc"

# Disable unnecessary dotfile creations
notify "Configuring Unnecessary Dotfiles"
if [[ $SUDO == 1 ]]; then
	if [[ $(awk '/./{line=$0} END{print line}' /etc/bashrc) != "unset HISTFILE" ]]; then
		echo "unset HISTFILE" | sudo tee -a "/etc/bashrc"
	fi
fi

export LESSHISTFILE=-
command rm -rf "$HOME/.bashrc"

# Link launchd jobs
notify "Linking Launch Agents"
command mkdir -p "$HOME/Library/LaunchAgents"

command rm -rf "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command ln -s "$DOTDIR/launchd/me.tale.cleanup.plist" "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command chmod +x "$DOTDIR/launchd/me.tale.cleanup.sh"
launchdload "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
