#!/usr/bin/env bash

notify "Configuring macOS dotfiles"
source "$HOME/.zshenv"

command ln -sf "$DOTDIR/config/.theosrc" "$HOME/.theosrc"
command ln -sf "$DOTDIR/config/.alacritty.yaml" "$HOME/.alacritty.yml"

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
command ln -sf "$DOTDIR/config/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

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
command launchctl unload "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command launchctl load "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"

# Defaults
notify "Configuring macOS defaults"

defaults write com.apple.screencapture type png
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0.5
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.Dock showhidden -bool TRUE

# Finish
killall Dock
notify "Finished configuration (maybe restart?)"
source "$HOME/.zshenv"
source "$HOME/.zshrc"
source "$HOME/.zlogin"
