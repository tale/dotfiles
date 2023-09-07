# Configure dirty dotfiles
notify "Configuring shared dotfiles"

command mkdir -p "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/config" ]]; then
	command touch "$HOME/.ssh/config"
fi

grep -qxF "Include ~/.config/dotfiles/config/ssh.config" "$HOME/.ssh/config" || echo "Include ~/.config/dotfiles/config/ssh.config" | $SUDO tee -a "$HOME/.ssh/config"
