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
	exit 1
}

# Checks before running the script
[[ -z "$HOME" ]] && error "\$HOME is not set"

if [[ -z "$IGNORE_DOTDIR" && ! -z "$DOTDIR" ]]; then
	error "\$DOTDIR is already set\nDotfiles should already be configured"
fi

command -v git &>/dev/null || error "'git' is not installed"
command -v curl &>/dev/null || error "'curl' is not installed"

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
	rm -rf "$DOTDIR"
fi

notify "Cloning dotfiles from '$DOTFILES_REPO'"
git clone --recursive "$DOTFILES_REPO" "$DOTDIR"

if [[ "$OS" == "Darwin" ]]; then
		source "$DOTDIR/bootstrap/macos.sh"
else
		source /etc/os-release
		if [[ $ID != "ubuntu" && $ID_LIKE != "debian" ]]; then
			error "Not running on Ubuntu"
		fi

		if [[ $VERSION_ID != "22.04" ]]; then
			error "Not running on Ubuntu Jammy Jellyfish (22.04)"
		fi

		source "$DOTDIR/bootstrap/linux.sh"
fi

notify "Installing pnpm"
curl -fsSL https://get.pnpm.io/install.sh | SHELL=`which zsh` sh -
source "$HOME/.zshrc"

pnpm env use --global lts
pnpm add -g pnpm # Upgrade pnpm after installation

notify "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

source "$HOME/.cargo/env"
rustup default stable

# Configure dirty dotfiles
notify "Configuring shared dotfiles"

mkdir -p "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/config" ]]; then
	touch "$HOME/.ssh/config"
fi

grep -qxF "Include ~/.config/dotfiles/config/ssh.config" "$HOME/.ssh/config" || echo "Include ~/.config/dotfiles/config/ssh.config" | $SUDO tee -a "$HOME/.ssh/config"

touch "$HOME/.hushlogin"
ln -sf "$DOTDIR/config/.huskyrc" "$HOME/.huskyrc"

notify "Configuring zsh"
ln -sf "$DOTDIR/config/zsh/.zshenv" "$HOME/.zshenv"
source "$HOME/.zshenv" # Loads $ZDOTDIR

rm -rf "$ZDOTDIR" && mkdir -p "$ZDOTDIR"
ln -sf "$DOTDIR/config/zsh/.zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$DOTDIR/config/zsh/.zlogin" "$ZDOTDIR/.zlogin"

notify "Configuring git"
rm -rf "$HOME/.gitconfig"
ln -sf "$DOTDIR/config/git/.gitconfig" "$HOME/.gitconfig"

rm -rf "$HOME/.config/git"
mkdir -p "$HOME/.config/git"
ln -sf "$DOTDIR/config/git/.gitignore" "$HOME/.config/git/.gitignore"

ln -sf "$DOTDIR/config/git/hooks" "$HOME/.config/git/hooks"
for hook in "$DOTDIR/config/git/hooks/"*; do
	chmod +x "$hook"
done

notify "Configuring Neovim and Tmux"
rm -rf "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTDIR/config/nvim/lua" "$HOME/.config/nvim/lua"
ln -sf "$DOTDIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

nvim --headless "+Lazy! sync" +qa # Installs plugins via Lazy
ln -sf "$DOTDIR/config/tui/tmux.conf" "$HOME/.tmux.conf"

notify "Finished configuration (maybe restart?)"
rm -rf "$HOME/.zshrc"
rm -rf "$HOME/.zlogin"

source "$HOME/.zshenv"
source "$ZDOTDIR/.zshrc"
source "$ZDOTDIR/.zlogin"
