#!/usr/bin/env bash
cd ~
shopt -s dotglob

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

error() {
	echo -e "\033[0;31m[x]\033[0m $1" >&2
}

DOTDIR="$HOME/.dotfiles"

# Check for sudo
if $(sudo -v); then
	SUDO=1
else
	SUDO=0
fi

if [[ -d $DOTDIR ]]; then
	echo "$DOTDIR already exists and may not be empty"
	echo -n "Continue, exit, or overwrite directory (c,e,o): "
	read CHOICE

	if [[ $CHOICE == "e" ]]; then
		exit 1
	elif [[ $CHOICE == "o" ]]; then
		command rm -rf $DOTDIR
	fi
else
	echo "Cloning dotfiles"
	command git clone https://github.com/tale/dotfiles "$DOTDIR"
fi

command touch "$HOME/.hushlogin"

# Configure git config
command rm -rf "$HOME/.gitconfig"
command ln -s "$DOTDIR/.gitconfig" "$HOME/.gitconfig"
command chmod +x $DOTDIR/githooks/* # Can't be in quotes to fix bashisms in Linux

command rm -rf "$HOME/.huskyrc"
command ln -s "$DOTDIR/.huskyrc" "$HOME/.huskyrc"
echo "source ~/.dotfiles/.zshrc" > "$HOME/.zshrc"

if [[ $(uname -s) == "Darwin" ]]; then
	source "$DOTDIR/configure/macos.sh"
fi

if [[ $(uname -s) == "Linux" ]]; then
	source /etc/os-release
	if [[ $ID != "ubuntu" && $ID_LIKE != "debian" ]]; then
		error "Not running on Ubuntu (Debian Like)"
		exit 2
	fi

	if [[ $VERSION_ID != "22.04" && $VERSION_ID != "20.04" ]]; then
		error "Not running on Focal Fossa (20.04) or Jammy Jellyfish (22.04)"
		exit 3
	fi

	source "$DOTDIR/configure/linux.sh"
fi
