#!/usr/bin/env bash
cd ~
shopt -s dotglob

notify() {
	echo -e "\n\033[0;34m[i]\033[0m $1" >&2
}

DOTDIR="$HOME/.dotfiles"

# Check for sudo
if $(sudo -v); then
	SUDO=1
else
	SUDO=0
fi

if [[ -d $DOTDIR ]];
then
	echo "$DOTDIR already exists and may not be empty"
	echo -n "Continue, exit, or overwrite directory (c,e,o): "
	read CHOICE

	if [[ $CHOICE == "e" ]];
	then
		exit 1
	elif [[ $CHOICE == "o" ]];
	then
		command rm -rf $DOTDIR
	fi
else
	echo "Cloning dotfiles"
	command git clone https://github.com/tale/dotfiles "$DOTDIR"
fi

# Configure git config
command rm -rf "$HOME/.gitconfig"
command ln -s "$DOTDIR/.gitconfig" "$HOME/.gitconfig"
command git config --global core.excludesfile $DOTDIR/.gitignore
command git config --global core.hooksPath $DOTDIR/githooks
command chmod +x "$DOTDIR/githooks/*"

command rm -rf "$HOME/.huskyrc"
command ln -s "$DOTDIR/.huskyrc" "$HOME/.huskyrc"
echo "source ~/.dotfiles/.zshrc" > "$HOME/.zshrc"

if [[ $(uname -s) == "Darwin" ]];
then
	source "$DOTDIR/configure/macos.sh"
fi
