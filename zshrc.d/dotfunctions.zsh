dotsource() {
	source "$HOME/.zshrc"
}

dotdate() {
	builtin cd "$DOTDIR"
	command git stash
	command git pull
	command git stash pop
	builtin cd -
}

dotcode() {
	command code "$DOTDIR"
}
