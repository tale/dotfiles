# Workaround non TTY GPG
if [[ -z "$GPG_TTY" ]]; then
	export GPG_TTY=$(tty)
fi

alias cat='batcat' # bat(1) is named as batcat on Ubuntu
alias bat='batcat'

alias fd='fdfind' # fd(1) is named as fdfind on Ubuntu
alias find='fdfind'
