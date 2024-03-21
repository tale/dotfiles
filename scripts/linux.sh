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

sudo dnf install -y --allowerasing "${pkgs_list[@]}"
setup_dotfiles
