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
