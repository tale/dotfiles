#!/usr/bin/env bash

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

error() {
	echo -e "\033[0;31m[x]\033[0m $1" >&2
	exit 1
}

acquire_sudo() {
	if [[ $UID == 0 ]]; then
		notify "Running as root"
		SUDO=""
	elif $(sudo -v); then
		notify "Got sudo permissions"
		SUDO="sudo"
	else
		error "Failed to get sudo permissions"
	fi
}

prompt() {
	echo -en "\033[0;33m[?]\033[0m $1 \033[0;33m(y/N)\033[0m "
	read -r INPUT

	[[ "$INPUT" =~ ^[Yy]$ ]] && return 0 || return 1
}

# Variables
OS=$(uname -s)
DOTDIR="$HOME/Developer/personal/dotfiles"
DOTDIR_REPO="https://github.com/tale/dotfiles"

NIX_SCRIPT="https://nixos.org/nix/install"
BREW_SCRIPT="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Requirements
command -v git &>/dev/null || error "'git' is not installed"
command -v curl &>/dev/null || error "'curl' is not installed"
acquire_sudo

# Install Homebrew if not already installed
if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
	notify "Installing Homebrew"

	curl -fsSL "$BREW_SCRIPT" | NONINTERACTIVE=1 bash
	eval $(/opt/homebrew/bin/brew shellenv)
else
	notify "Homebrew is already installed"
fi

# Install Rosetta if not already installed
if ! command -v pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto &>/dev/null; then
	notify "Installing Rosetta"
	softwareupdate --install-rosetta --agree-to-license
else
	notify "Rosetta is already installed"
fi

# Install Nix if not already installed
if ! launchctl print system/org.nixos.nix-daemon &>/dev/null; then
	notify "Installing Nix"
	curl -L "$NIX_SCRIPT" | sh -s -- --daemon
	source /etc/bashrc
else
	notify "Nix is already installed"
	source /etc/static/bashrc
fi

if [[ ! -d "$DOTDIR" ]]; then
	notify "Cloning dotfiles from $DOTDIR_REPO"
	git clone "$DOTDIR_REPO" "$DOTDIR"
else
	notify "Dotfiles are already cloned"
fi

# Build and configure nix-darwin
if ! command -v darwin-rebuild &>/dev/null; then
	notify "Installing nix-darwin"

	# flake.nix expects "Aarnavs-MBP" as the hostname
	$SUDO scutil --set LocalHostName Aarnavs-MBP
	dscacheutil -flushcache

	# After nix-darwin is installed and configured it's in the PATH
	command nix build .#darwinConfigurations.$(hostname -s).system \
		--extra-experimental-features "nix-command flakes"

	# We need to link run to private/var/run for nix-darwin
	if ! grep -q "private/var/run" /etc/synthetic.conf; then
		notify "Appending nix-darwin path to /etc/synthetic.conf"

		printf "run\tprivate/var/run\n" | $SUDO tee -a /etc/synthetic.conf
		/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	else
		notify "nix-darwin path already exists in /etc/synthetic.conf"
	fi

	# Run nix-darwin's rebuild command
	$DOTDIR/result/sw/bin/darwin-rebuild switch --flake $DOTDIR
else
	notify "nix-darwin is already installed"
fi

# Setup the dotfiles to be managed by remote via SSH
git -C $DOTDIR remote set-url origin git@github.com:tale/dotfiles.git
