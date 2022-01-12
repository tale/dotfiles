dotsource() {
	source "$HOME/.zshrc"
}

dotdate() {
	builtin cd "$DOTDIR"
	command git pull
	builtin cd -
	source "$HOME/.zshrc"
}

dotcode() {
	command code "$DOTDIR"
}
