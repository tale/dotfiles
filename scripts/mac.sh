#!/usr/bin/env bash

BREW_SCRIPT="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL $BREW_SCRIPT)"
fi

brew install git openssl@3 stow
setup_dotfiles

brew bundle --global -v
rustup-init --no-modify-path -y

shell="$(brew --prefix)/bin/bash"
if [[ $(finger $USER | awk '/Shell:/ {print $4}') != "$shell" ]]; then
	if [ -f /etc/shells ]; then
		if ! grep -q $shell /etc/shells; then
			echo "Adding $shell to /etc/shells"
			echo $shell | sudo tee -a /etc/shells
		fi
	fi

	echo "Changing shell to $shell"
	sudo chsh -s $shell $USER
fi

# Defaults
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g AppleFontSmoothing -int 1
defaults write org.alacritty AppleFontSmoothing -int 0
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000.0
defaults write com.apple.dock wvous-tl-corner -int 12
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-br-corner -int 11
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

kill_dock=0
dockutil=$(which dockutil)

if ! $dockutil --find 'Google Chrome' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /Applications/Google\ Chrome.app -p 0 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Messages' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /System/Applications/Messages.app -p 1 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Calendar' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /System/Applications/Calendar.app -p 2 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Mail' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /System/Applications/Mail.app -p 3 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Things3' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /Applications/Things3.app -p 4 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Spotify' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add /Applications/Spotify.app -p 5 --no-restart $HOME
	kill_dock=1
fi

if ! $dockutil --find 'Downloads' &> /dev/null; then
	$DRY_RUN_CMD $dockutil --add '~/Downloads' -p 6 \
		--view grid --display folder \
		--section others --no-restart $HOME
	kill_dock=1
fi

if [[ $kill_dock -eq 1 ]]; then
	$DRY_RUN_CMD killall Dock
fi

sudo scutil --set ComputerName "Aarnav's MacBook Pro"
sudo scutil --set HostName "Aarnavs-MBP"
dscacheutil -flushcache
