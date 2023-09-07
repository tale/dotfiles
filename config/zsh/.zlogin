# The idea here is to compile Zsh scripts if they're stale
# Loading Zsh Code Word is faster than parsing script files for the shell
{
	setopt extended_glob
	hot_compile() {
		if [[ ! -s "$1" ]]; then
			return
		fi

		if [[ ! -s "$1.zwc" ]]; then
			[[ -v HM_REBUILD ]] && echo "Compiling $1"
			zcompile "$1"
			return
		fi

		if find "$1" -prune -newer "$1.zwc" | grep -q '^'; then
			[[ -v HM_REBUILD ]] && echo "Recompiling $1"
			zcompile "$1"
			return
		fi
	}

	# Significant speedup when compiling completion cache
	for file in ${ZDOTDIR:-$HOME}/.zcomp^(*.zwc)(.); do
		hot_compile "$file"
	done

	hot_compile "${ZDOTDIR:-$HOME}/.zshrc"
	hot_compile "$DOTDIR/config/zsh/lscolors.zsh"
} &!

