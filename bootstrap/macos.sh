#!/usr/bin/env bash
echo "Installing brew & formulae from Brewfile"
command curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
command brew tap homebrew/bundle
command brew bundle --no-lock --file "$DOTDIR/Brewfile"

# Post-brew installations
notify "Running post-brew configurations"
command curl -fsSL https://get.pnpm.io/install.sh | sh -
command pnpm add -g pnpm # Upgrade pnpm after installation
command pnpm env use --global 18

command mkdir -p "$HOME/.gnupg" && rm -rf "$HOME/.gnupg/gpg-agent.conf" # Reconfigure gpg-agent.conf
echo -e "pinentry-program /usr/local/bin/pinentry-mac\nenable-ssh-support" >> "$HOME/.gnupg/gpg-agent.conf"

# Install and Configure Theos
notify "Installing Theos"
THEOS="$HOME/Library/Theos"
if [[ ! -d $THEOS ]]; then
	command git clone --recursive https://github.com/theos/theos.git $THEOS
else
	echo "$THEOS already exists. Not cloning again."
fi

command rm -rf "$HOME/.theosrc"
command ln -s "$DOTDIR/.theosrc" "$HOME/.theosrc"
command rm -rf "$HOME/.alacritty.yml"
command ln -s "$DOTDIR/.alacritty.yaml" "$HOME/.alacritty.yml"

# Disable unnecessary dotfile creations
notify "Configuring Unnecessary Dotfiles"
if [[ $SUDO != "UNSET" ]]; then
	if [[ $(awk '/./{line=$0} END{print line}' /etc/bashrc) != "unset HISTFILE" ]]; then
		echo "unset HISTFILE" | $SUDO tee -a "/etc/bashrc"
	fi
fi

export LESSHISTFILE=-
command rm -rf "$HOME/.bashrc"

if [[ $SUDO == "UNSET" ]]; then
	error "Cannot configure Launch Agents without sudo"
	exit 3
fi

# Link launchd jobs
notify "Linking Launch Agents"
command mkdir -p "$HOME/Library/LaunchAgents"

# Cleanup Task
command rm -rf "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command ln -s "$DOTDIR/launchd/me.tale.cleanup.plist" "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command chmod +x "$DOTDIR/launchd/me.tale.cleanup.sh"
command launchctl unload "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"
command launchctl load "$HOME/Library/LaunchAgents/me.tale.cleanup.plist"

# Appearance Task
command rm -rf "$HOME/Library/LaunchAgents/me.tale.appearance.plist"
command ln -s "$DOTDIR/launchd/me.tale.appearance.plist" "$HOME/Library/LaunchAgents/me.tale.appearance.plist"
command chmod +x "$DOTDIR/launchd/me.tale.appearance.sh"
command launchctl unload "$HOME/Library/LaunchAgents/me.tale.appearance.plist"
command launchctl load "$HOME/Library/LaunchAgents/me.tale.appearance.plist"

# Network Interface Stream Fix
command mkdir -p "/Library/LaunchDaemons"
command $SUDO ln -s "$DOTDIR/launchd/me.tale.streamfix.plist" "/Library/LaunchDaemons/me.tale.streamfix.plist"
command $SUDO chmod +x "$DOTDIR/launchd/me.tale.streamfix.sh"
command $SUDO chown root:admin "/Library/LaunchDaemons/me.tale.streamfix.plist"
command $SUDO launchctl unload "/Library/LaunchDaemons/me.tale.streamfix.plist"
command $SUDO launchctl load "/Library/LaunchDaemons/me.tale.streamfix.plist"

# Defaults
defaults write com.apple.screencapture type png

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0.5

defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
defaults write com.apple.Dock showhidden -bool TRUE

killall Dock
