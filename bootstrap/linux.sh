#!/usr/bin/env bash
APT_LIST="bat exa fd-find fzf git gnupg2 htop less make build-essential neofetch tmux unzip watch wget zip zstd"


if [[ $SUDO == "UNSET" ]] && error "Cannot configure Linux without sudo permissions"

# Install ZSH if necessary
command -v zsh &>/dev/null || notify "Installing ZSH" && APT_LIST="$APT_LIST zsh"

# This assumes we are on an arm64 machine and arm64 docker container!
DELTA_DEB="https://raw.githubusercontent.com/tale/dotfiles/main/assets/git-delta_0.15.1_arm64.deb"
NEOVIM_DEB="https://raw.githubusercontent.com/tale/dotfiles/main/assets/neovim_0.8.3_arm64.deb"

notify "Updating distribution packages"
$SUDO apt-get update && $SUDO apt-get dist-upgrade -yq

notify "Installing Delta"
curl -sL "$DELTA_DEB" -o /tmp/delta.deb
$SUDO dpkg -i /tmp/delta.deb

notify "Installing Neovim"
curl -sL "$NEOVIM_DEB" -o /tmp/neovim.deb
$SUDO dpkg -i /tmp/neovim.deb

notify "Installing packages from APT"
$SUDO apt-get install -yq $APT_LIST
chsh -s $(command -v zsh)

