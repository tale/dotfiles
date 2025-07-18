if [ $OS = Darwin ]; then
	eval $(/opt/homebrew/bin/brew shellenv)

	for dir in $HOMEBREW_PREFIX/opt/*/libexec/gnubin; do
		gnupath=$dir:$gnupath
	done

	for dir in $HOMEBREW_PREFIX/opt/*/libexec/gnuman; do
		gnuman=$dir:$gnuman
	done

	export PATH=$gnupath:$PATH
	export MANPATH=$gnuman:$MANPATH

	. $HOME/.cargo/env
	. $HOME/.orbstack/shell/init.zsh
fi
