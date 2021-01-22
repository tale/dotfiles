if which brew >/dev/null 2>&1; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source "${HOME}/.zgen/zgen.zsh"
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

if ! zgen saved; then
	zgen load zsh-users/zsh-autosuggestions
	zgen load zsh-users/zsh-completions
	zgen load zsh-users/zsh-syntax-highlighting
	zgen load zsh-users/zsh-history-substring-search
	zgen load subnixr/minimal
	zgen save
fi

export NVM_DIR="$HOME/.nvm"
declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")
NODE_GLOBALS+=("devspace")


load_nvm_darwin () {
	export NVM_PREFIX=$(brew --prefix nvm)
	[ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
}

load_nvm_linux () {
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

export NVM_LOADER="load_nvm"
if [ $(uname) = "Darwin" ]; then
	NVM_LOADER="load_nvm_darwin"
elif [ $(uname) = "Linux" ]; then
	NVM_LOADER="load_nvm_linux"
fi

for cmd in "${NODE_GLOBALS[@]}"; do
	eval "${cmd} () { unset -f ${NODE_GLOBALS}; ${NVM_LOADER}; ${cmd} \$@ }"
done
