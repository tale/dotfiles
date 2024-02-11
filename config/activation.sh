#!/usr/bin/env bash
# Ran by home-manager activation

SUDO=$(which sudo)
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

