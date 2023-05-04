#!/usr/bin/env bash

notify "Configuring macOS dotfiles"
source "$HOME/.zshenv"

command mkdir -p "$HOME/.config/alacritty"
command ln -sf "$DOTDIR/config/tui/alacritty.yaml" "$HOME/.config/alacritty/alacritty.yml"
command ln -sf "$DOTDIR/config/.theosrc" "$HOME/.theosrc"

notify "Installing Homebrew"
command curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
command brew tap homebrew/bundle

notify "Installing Homebrew packages"
command brew bundle --no-lock --file "$DOTDIR/Brewfile"

notify "Installing bun"
command curl -fsSL https://bun.sh/install | bash
tail -n 3 "$ZDOTDIR/.zshrc" | wc -c | xargs -I {} truncate "$ZDOTDIR/.zshrc" -s -{} # Cut last 3 lines that bun adds

notify "Configuring GnuPG"
command mkdir -p "$HOME/.gnupg"
command chown -R $(whoami) "$HOME/.gnupg"
command chmod 600 "$HOME/.gnupg/*"
command chmod 700 "$HOME/.gnupg"

command ln -sf "$DOTDIR/config/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
command ln -sf "$DOTDIR/config/gnupg/dirmngr.conf" "$HOME/.gnupg/dirmngr.conf"
command ln -sf "$DOTDIR/config/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"

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

if [[ $SUDO == "UNSET" ]]; then
	warning "Skipping Launch Agent configuration without sudo"
	exit 0
fi

notify "Linking Launch Agents"
command mkdir -p "$HOME/Library/LaunchAgents"

command ln -sf "$DOTDIR/launchd/me.tale.cleanup.plist" "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command chmod +x "$DOTDIR/launchd/me.tale.cleanup.sh"

command ln -sf "$DOTDIR/launchd/me.tale.backup.plist" "$HOME/Library/LaunchAgents/me.tale.backup.plist"
command chmod +x "$DOTDIR/launchd/me.tale.backup.sh"

command launchctl unload "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command launchctl load "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"

command launchctl unload "$HOME/Library/LaunchAgents/me.tale.backup.plist"
command launchctl load "$HOME/Library/LaunchAgents/me.tale.backup.plist"

# Defaults
notify "Configuring macOS defaults"

defaults write com.apple.screencapture type png
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0.5
defaults write com.apple.Dock showhidden -bool TRUE

# Application Settings
notify "Configuring macOS application defaults"
command ln -sf "$DOTDIR/config/alacritty.yaml" "$HOME/.alacritty.yml"

# Finish
killall Dock
