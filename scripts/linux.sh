#!/usr/bin/env bash

base_pkgs=(curl git openssl 'dnf-command(config-manager)')
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

if [ -z "$SKIP_1PW" ]; then
	cat <<EOF | sudo tee /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable
baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
fi

pkgs_list=(
	curl
	fd-find
	fzf
	git
	git-delta
	gnupg2
	golang
	htop
	jq
	kubectl
	less
	make
	neovim
	openssl
	postgresql
	ripgrep
	rsync
	sqlite
	stow
	sudo
	tmux
	wget
)

# Check if we are in Fedora or RHEL/Derivatives
source /etc/os-release

case $ID in
	fedora)
		pkgs_list+=(
			go-task
			rustup
		)
		;;
	ol)
		base_pkgs+=(epel-release)
		sudo dnf install -y --allowerasing "${base_pkgs[@]}"
		sudo dnf config-manager --enable ol9_developer_EPEL
		;;

	rocky)
		base_pkgs+=(epel-release)
		sudo dnf install -y --allowerasing "${base_pkgs[@]}"
		sudo dnf config-manager --set-enabled crb
		sudo crb enable
		;;
	*)
		echo "Unsupported OS: $ID"
		exit 1
		;;
esac

if [ -z "$SKIP_1PW" ]; then
	pkgs_list+=(1password-cli)
fi

sudo dnf install -y --allowerasing "${pkgs_list[@]}"
setup_dotfiles

if [ -z "$SKIP_1PW" ]; then
	read -s -p "Enter 1Password Service Token: " token
	export OP_SERVICE_ACCOUNT_TOKEN=$token
	echo

	# Check for the status code of op whoami
	if ! op whoami; then
		echo "Invalid service token"
		exit 1
	fi

	op read "op://Developer/Key/private key?ssh-format=openssh" > ~/.ssh/id_ed25519
	op read "op://Developer/Key/public key" > ~/.ssh/id_ed25519.pub

	chmod 600 ~/.ssh/id_ed25519
	chmod 644 ~/.ssh/id_ed25519.pub
fi
