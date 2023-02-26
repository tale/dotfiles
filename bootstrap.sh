#!/usr/bin/env bash
# if $HOME is unset exit early

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

warn() {
	echo -e "\033[0;33m[!]\033[0m $1" >&2
}

error() {
	echo -e "\033[0;31m[x]\033[0m $1" >&2
}

# Checks before running the script
if [[ -z "$HOME" ]]; then
	error "\$HOME is not set"
	exit 1
fi

if [[ -z "$IGNORE_DOTDIR" && ! -z "$DOTDIR" ]]; then
	error "\$DOTDIR is already set"
	error "Dotfiles should already be configured"
	exit 1
fi

if ! $(command -v git > /dev/null 2>&1); then
	error "'git' is not installed"
	exit 1
fi

if ! $(command -v curl > /dev/null 2>&1); then
	error "'curl' is not installed"
	exit 1
fi

cd "$HOME"

# Check if sudo is available
if [[ -z "$NO_SUDO" ]]; then
	notify "Checking for 'sudo' permissions"
	if [[ $UID == 0 ]]; then
		notify "Running as root"
		SUDO=""
	elif $(sudo -v); then
		notify "Got 'sudo' permissions"
		SUDO=sudo
	else
		warn "Failed to get 'sudo' permissions"
		warn "Skipping because \$NO_SUDO is not set"
		SUDO="UNSET"
	fi
else
	warn "Skipping because \$NO_SUDO is set"
	SUDO="UNSET"
fi

# Clone the dotfiles repo
DOTDIR="$HOME/.config/dotfiles"
DOTFILES_REPO="https://github.com/tale/dotfiles"

notify "Using directory: $DOTDIR"

if [[ -d "$DOTDIR" ]]; then
	warn "Removing existing '$DOTDIR'"
	command rm -rf "$DOTDIR"
fi

notify "Cloning dotfiles from '$DOTFILES_REPO'"
command git clone --recursive "$DOTFILES_REPO" "$DOTDIR"

if [[ "$OS" == "Darwin" ]]; then
		source "$DOTDIR/bootstrap/macos.sh"
else
		source /etc/os-release
		if [[ $ID != "ubuntu" && $ID_LIKE != "debian" ]]; then
			error "Not running on Ubuntu"
			exit 1
		fi

		if [[ $VERSION_ID != "22.04" ]]; then
			error "Not running on Ubuntu Jammy Jellyfish (22.04)"
			exit 1
		fi

		source "$DOTDIR/bootstrap/linux.sh"
fi

notify "Installing pnpm"
command curl -fsSL https://get.pnpm.io/install.sh | SHELL=`which zsh` sh -
source "$HOME/.zshrc"

command pnpm env use --global lts
command pnpm add -g pnpm # Upgrade pnpm after installation

notify "Installing rust"
command curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

source "$HOME/.cargo/env"
command rustup default stable

# Configure dirty dotfiles
notify "Configuring shared dotfiles"

command mkdir -p "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/config" ]]; then
	command touch "$HOME/.ssh/config"
fi

grep -qxF "Include ~/.config/dotfiles/config/ssh.config" "$HOME/.ssh/config" || echo "Include ~/.config/dotfiles/config/ssh.config" | $SUDO tee -a "$HOME/.ssh/config"

command touch "$HOME/.hushlogin"
command ln -sf "$DOTDIR/config/.huskyrc" "$HOME/.huskyrc"

notify "Configuring zsh"
command ln -sf "$DOTDIR/config/zsh/.zshenv" "$HOME/.zshenv"
source "$HOME/.zshenv" # Loads $ZDOTDIR

command rm -rf "$ZDOTDIR" && mkdir -p "$ZDOTDIR"
command ln -sf "$DOTDIR/config/zsh/.zshrc" "$ZDOTDIR/.zshrc"
command ln -sf "$DOTDIR/config/zsh/.zlogin" "$ZDOTDIR/.zlogin"

notify "Configuring git"
command rm -rf "$HOME/.gitconfig"
command ln -sf "$DOTDIR/config/git/.gitconfig" "$HOME/.gitconfig"

command rm -rf "$HOME/.config/git"
command mkdir -p "$HOME/.config/git"
command ln -sf "$DOTDIR/config/git/.gitignore" "$HOME/.config/git/.gitignore"

command ln -sf "$DOTDIR/config/git/hooks" "$HOME/.config/git/hooks"
for hook in "$DOTDIR/config/git/hooks/"*; do
command chmod +x "$hook"
done

notify "Finished configuration (maybe restart?)"
command rm -rf "$HOME/.zshenv"
command rm -rf "$HOME/.zshrc"
command rm -rf "$HOME/.zlogin"

source "$ZDOTDIR/.zshenv"
source "$ZDOTDIR/.zshrc"
source "$ZDOTDIR/.zlogin"
