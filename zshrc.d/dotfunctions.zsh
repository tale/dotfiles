dotsource() {
	source "$HOME/.zshrc"
}

dotdate() {
	command git -C "$DOTDIR" stash
	command git -C "$DOTDIR" pull
	command git -C "$DOTDIR" stash pop
	source "$HOME/.zshrc"
}
