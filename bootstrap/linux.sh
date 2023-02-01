#!/usr/bin/env bash
APT_LIST="bat exa fd-find fzf git git-delta gnupg2 htop less make build-essential neofetch neovim tmux unzip watch wget zip zstd"

if [[ $SUDO == "UNSET" ]]; then
	error "Cannot configure Linux without sudo permissions"
	exit 3
fi

# Install ZSH if necessary
if [[ -z $(command -v zsh) ]]; then
	warn "Missing 'zsh'"
	APT_LIST="$APT_LIST zsh"
fi

notify "Updating distribution packages"
command $SUDO apt-get update && $SUDO apt-get dist-upgrade -yq

notify "Installing $APT_LIST"
command $SUDO apt-get install -yq $APT_LIST
command chsh -s $(which zsh)
