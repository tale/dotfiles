#!/usr/bin/env bash
# Ran by home-manager activation

export PATH="/usr/bin"

user="tale"
shell="/run/current-system/sw/bin/bash"
default="/Library/Preferences/com.apple.security.smartcard UserPairing"

if [[ $(finger $user | awk '/Shell:/ {print $4}') != "$shell" ]]; then
	$DRY_RUN_CMD sudo chsh -s $shell $user
fi

# Workaround to nix-darwin not running defaults as sudo
if [[ $(sudo defaults read $default) != "0" ]]; then
	$DRY_RUN_CMD sudo defaults write $default -bool false
fi

gpg=$(which gpg)
key="3205E18CEDD2C007"
server="hkps://pgp.mit.edu"

if ! gpg --list-keys $key &> /dev/null; then
	$DRY_RUN_CMD $gpg --keyserver $server --recv-keys $key
	$DRY_RUN_CMD echo -e "5\ny\n" | $gpg --command-fd 0 --expert --edit-key $key trust
fi

# Invoking this will install the default toolchain
$DRY_RUN_CMD $(which rustup) show active-toolchain

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
