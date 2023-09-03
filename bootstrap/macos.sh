#!/usr/bin/env bash

notify "Configuring macOS dotfiles"
source "$HOME/.zshenv"

mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTDIR/config/tui/alacritty.yaml" "$HOME/.config/alacritty/alacritty.yml"
ln -sf "$DOTDIR/config/.theosrc" "$HOME/.theosrc"

notify "Installing Homebrew"
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
brew tap homebrew/bundle

notify "Installing Homebrew packages"
brew bundle --no-lock --file "$DOTDIR/Brewfile"

notify "Installing bun"
curl -fsSL https://bun.sh/install | bash
tail -n 3 "$ZDOTDIR/.zshrc" | wc -c | xargs -I {} truncate "$ZDOTDIR/.zshrc" -s -{} # Cut last 3 lines that bun adds

notify "Configuring GnuPG"
mkdir -p "$HOME/.gnupg"
chown -R $(whoami) "$HOME/.gnupg"
chmod 600 "$HOME/.gnupg/*"
chmod 700 "$HOME/.gnupg"

ln -sf "$DOTDIR/config/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
ln -sf "$DOTDIR/config/gnupg/dirmngr.conf" "$HOME/.gnupg/dirmngr.conf"
ln -sf "$DOTDIR/config/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"

notify "Installing Theos"
THEOS="$HOME/Library/Theos"
if [[ ! -d $THEOS ]]; then
	command git clone --recursive https://github.com/theos/theos.git $THEOS
else
	warn "$THEOS already exists. Updating instead."
	command git -C "$THEOS" pull
fi

notify "Disabling unnecessary dotfile creations"
if [[ $SUDO != "UNSET" ]]; then
	if [[ $(awk '/./{line=$0} END{print line}' /etc/bashrc) != "unset HISTFILE" ]]; then
		echo "unset HISTFILE" | $SUDO tee -a "/etc/bashrc"
	fi
fi

export LESSHISTFILE=-
command rm -rf "$HOME/.bashrc"


if [[ $SUDO != "UNSET" ]]; then
	notify "Disabling Smartcard pairing prompts"
	$SUDO defaults write /Library/Preferences/com.apple.security.smartcard UserPairing -bool false
fi

if [[ $SUDO == "UNSET" ]]; then
	warning "Skipping Launch Agent configuration without sudo"
	exit 0
fi

notify "Linking Launch Agents"
mkdir -p "$HOME/Library/LaunchAgents"

ln -sf "$DOTDIR/launchd/me.tale.cleanup.plist" "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
chmod +x "$DOTDIR/launchd/me.tale.cleanup.sh"

ln -sf "$DOTDIR/launchd/me.tale.backup.plist" "$HOME/Library/LaunchAgents/me.tale.backup.plist"
chmod +x "$DOTDIR/launchd/me.tale.backup.sh"

launchctl unload "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
launchctl load "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"

launchctl unload "$HOME/Library/LaunchAgents/me.tale.backup.plist"
launchctl load "$HOME/Library/LaunchAgents/me.tale.backup.plist"

# Defaults
notify "Configuring macOS defaults"

defaults write com.apple.screencapture type png
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0.5
defaults write com.apple.Dock showhidden -bool TRUE

# Application Settings
notify "Configuring macOS application defaults"
ln -sf "$DOTDIR/config/alacritty.yaml" "$HOME/.alacritty.yml"

# Finish
killall Dock
