export EDITOR=nvim
export OS=$(uname -s)

if [ $OS = Darwin ]; then
	export SSH_AUTH_SOCK=$HOME/.config/1Password/agent.sock
fi
