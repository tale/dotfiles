# The idea here is to compile Zsh scripts if they're stale
# Loading Zsh Code Word is faster than parsing script files for the shell
{
	setopt extended_glob
	hot_compile() {
		if [[ -s "$1" && (! -s "${1}.zwc" || "$1" -nt "${1}.zwc") ]]; then
			zcompile "$1"
		fi
	}

	# Significant speedup when compiling completion cache
	for file in ${ZDOTDIR:-$HOME}/.zcomp^(*.zwc)(.); do
		hot_compile "$file"
	done

	hot_compile "${ZDOTDIR:-$HOME}/.zshrc"
	hot_compile "$DOTDIR/config/zsh/macos.zsh"
	hot_compile "$DOTDIR/config/zsh/linux.zsh"
	hot_compile "$DOTDIR/config/zsh/lscolors.zsh"
} &!

