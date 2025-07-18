export EDITOR=nvim
export OS=$(uname -s)
export IS_DEV_VM=$(test -d /opt/orbstack-guest && echo true || echo false)

if [ $OS = Darwin ]; then
	export SSH_AUTH_SOCK=$HOME/.config/1Password/agent.sock
fi
