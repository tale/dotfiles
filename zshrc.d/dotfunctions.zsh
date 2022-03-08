dotsource() {
	source "$HOME/.zshrc"
}

dotdate() {
	command git -C "$DOTDIR" pull
	source "$HOME/.zshrc"
}
