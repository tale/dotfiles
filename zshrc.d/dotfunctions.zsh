dotsource() {
	source "$HOME/.zshrc"
}

dotdate() {
	command git pull -C "$DOTDIR"
	source "$HOME/.zshrc"
}
