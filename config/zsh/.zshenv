export ZDOTDIR="$HOME/.config/zsh"
export DOTDIR="$HOME/.config/dotfiles"
export OS=$(uname -s)
export PATH="$HOME/.local/bin:$PATH"
export LESSHISTFILE=-

# Add Homebrew to PATH on macOS
if [[ $OS == "Darwin" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_INSTALL_FROM_API=1
	export HOMEBREW_NO_ENV_HINTS=1
fi
