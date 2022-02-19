#!/usr/bin/env bash
DIFF_SO_FANCY_BIN="https://github.com/so-fancy/diff-so-fancy/releases/download/v1.4.2/diff-so-fancy"
EXA_ARCHIVE="https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip"
APT_LIST="bat fd-find fzf git gnupg2 htop less make build-essential neofetch neovim tmux unzip watch wget zip zstd"

if [[ $SUDO != 1 ]]; then
	error "Cannot configure Linux without sudo permissions"
	exit 3
fi

echo "Installing necessary dependents using APT"

if [ ! -n $ZSH_VERSION ]; then
	notify "Installing Zshell"
	command sudo apt install -yq zsh
	command chsh -s $(which zsh)
fi

command sudo curl $DIFF_SO_FANCY_BIN -Lo /usr/local/bin/diff-so-fancy
command sudo chmod +x /usr/local/bin/diff-so-fancy

if [[ $VERSION_ID == "22.04" ]]; then
	# The package is available on APT starting with Hirsute
	APT_LIST="$APT_LIST exa"
else
	command sudo curl $EXA_ARCHIVE -Lo /usr/local/exa.zip
	command sudo unzip /usr/local/exa.zip
fi

notify "Installing $APT_LIST"

command sudo apt-get update && sudo apt-get dist-upgrade -yq
command sudo apt-get install -yq $APT_LIST