#!/usr/bin/env bash
APT_LIST="bat exa fd-find fzf git gnupg2 htop less make build-essential neofetch tmux unzip watch wget zip zstd"

if [[ $SUDO == "UNSET" ]]; then
	error "Cannot configure Linux without sudo permissions"
	exit 3
fi

# Install ZSH if necessary
if [[ -z $(command -v zsh) ]]; then
	notify "Installing ZSH"
	APT_LIST="$APT_LIST zsh"
fi

# This assumes we are on an arm64 machine and arm64 docker container!
DELTA_DEB="https://raw.githubusercontent.com/tale/dotfiles/main/assets/git-delta_0.15.1_arm64.deb"
NEOVIM_DEB="https://raw.githubusercontent.com/tale/dotfiles/main/assets/neovim_0.8.3_arm64.deb"

notify "Updating distribution packages"
command $SUDO apt-get update && $SUDO apt-get dist-upgrade -yq

notify "Installing Delta"
command curl -sL "$DELTA_DEB" -o /tmp/delta.deb
command $SUDO dpkg -i /tmp/delta.deb

notify "Installing Neovim"
command curl -sL "$NEOVIM_DEB" -o /tmp/neovim.deb
command $SUDO dpkg -i /tmp/neovim.deb

notify "Installing packages from APT"
command $SUDO apt-get install -yq $APT_LIST
command chsh -s $(which zsh)

