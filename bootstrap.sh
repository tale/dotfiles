#!/usr/bin/env bash

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

warn() {
	echo -e "\033[0;33m[!]\033[0m $1" >&2
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
		notify "Got 'sudo' permissions"
		SUDO="sudo"
	else
		error "Failed to get 'sudo' permissions"
	fi
}

prompt() {
	echo -en "\033[0;33m[?]\033[0m $1 \033[0;33m(y/N)\033[0m "
	read -r INPUT

	[[ "$INPUT" =~ ^[Yy]$ ]] && return 0 || return 1
}

# Variables
OS=$(uname -s)
DOTDIR=${DOTDIR:-"$HOME/.config/dotfiles"}
DOTDIR_REPO="https://github.com/tale/dotfiles"

NIX_SCRIPT="https://nixos.org/nix/install"
BREW_SCRIPT="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Requirements
[[ -z "$HOME" ]] && error "\$HOME is not set"
command -v git &>/dev/null || error "'git' is not installed"
command -v curl &>/dev/null || error "'curl' is not installed"

cd "$HOME"
	
# Don't waste time with sudo until requirements pass
acquire_sudo

# Install Homebrew if not already installed
# This also installs Xcode Command Line Tools
if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
	notify "Installing Homebrew (required by Nix)"
	curl -fsSL "$BREW_SCRIPT" | NONINTERACTIVE=1 bash
	eval $(/opt/homebrew/bin/brew shellenv)
else
	warn "Homebrew is already installed (skipping...)"
fi

# Various setups
$SUDO scutil --set LocalHostName Aarnavs-MBP
dscacheutil -flushcache
mkdir -p "$HOME/Developer"
$SUDO softwareupdate --install-rosetta --agree-to-license

notify "Dotfiles: $DOTDIR"
if [[ ! -z "$SKIP_CLONE" ]]; then
	warn "Skipping clone because \$SKIP_CLONE is set"
else
	# Check if dotfiles are already installed
	[[ -d "$DOTDIR" ]] && error "Dotfiles already exist"

	# Once SSH and GnuPG are configured, clone via SSH
	# TODO: Or maybe just update the remotes to SSH
	notify "Cloning dotfiles from $DOTDIR_REPO"
	git clone "$DOTDIR_REPO" "$DOTDIR"
fi

cd "$DOTDIR"

# Install Nix in daemon-mode if not already installed
if ! launchctl print system/org.nixos.nix-daemon &>/dev/null; then
	notify "Installing Nix"
	curl -L "$NIX_SCRIPT" | sh -s -- --daemon
	source /etc/bashrc
else
	warn "Nix is already installed (skipping...)"
	source /etc/static/bashrc
fi

# Build and configure nix-darwin
if ! command -v darwin-rebuild &>/dev/null; then
	notify "Installing nix-darwin"

	# After nix-darwin is installed and configured it's in the PATH
	command nix build .#darwinConfigurations.$(hostname -s).system \
		--extra-experimental-features "nix-command flakes"

	# We need to link run to private/var/run for nix-darwin
	if ! grep -q "private/var/run" /etc/synthetic.conf; then
		notify "Appending nix-darwin path to /etc/synthetic.conf"
		printf "run\tprivate/var/run\n" | $SUDO tee -a /etc/synthetic.conf
		/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	else
		warn "nix-darwin path already exists in /etc/synthetic.conf"
	fi

	# Run nix-darwin's rebuild command
	$DOTDIR/result/sw/bin/darwin-rebuild switch --flake $DOTDIR
else
	warn "nix-darwin is already installed (skipping...)"
fi


# Open apps that need to be enabled at login
open -a "Raycast"
open -a "AlDente"
open -a "Cleanshot X"
open -a "Maccy"
open -a "Bartender 4"
open -a "MonitorControl"

git -C $DOTDIR remote set-url origin git@github.com:tale/dotfiles.git
notify "It's probably a good idea to reboot now"
