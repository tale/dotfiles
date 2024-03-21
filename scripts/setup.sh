#!/usr/bin/env bash
set -e # Exit on error

OS=$(uname -s)
DOTFILES="tale/dotfiles.git"

get_pass() {
	read -s -p "Enter Decryption Password: " pass
	export DECRYPT_PASS=$pass
	printf "\n"
}

decrypt_file() {
    local file_path="$1"
    local user_password

	if [ -f $file_path ]; then
		echo "File already exists: $file_path"
		return
	fi

    read -sp "Enter your password: " user_password
    echo

	echo "Decrypting the RSA key with the user password..."
	openssl enc \
		-d -pbkdf2 -iter 10000000 -salt -md sha512 \
		-aes-256-cbc -pass pass:"$user_password" \
		-in $file_path.blob.key -out $file_path.key

	echo "Decrypting the file with the RSA key..."
	openssl pkeyutl \
		-decrypt -inkey $file_path.key \
		-in $file_path.blob -out $file_path

	rm -f $file_path.key
	unset user_password
}

ensure_remote() {
	if ! command -v git &>/dev/null; then
		echo "Git not found"
		exit 1
	fi

	if [ -d .git ]; then
		if git remote -v | grep -q $DOTFILES; then
			echo $PWD
			return
		fi
	fi

	if [ -d dotfiles/.git ]; then
		if git -C dotfiles remote -v | grep -q $DOTFILES; then
			cd dotfiles
			echo $PWD
			return
		fi

		echo "Directory already exists and isn't remote: dotfiles"
		exit 1
	fi

	git clone --single-branch --branch main \
		https://github.com/${DOTFILES} dotfiles

	cd dotfiles
	echo $PWD
}

setup_dotfiles() {
	decrypt_file $PWD/files/.ssh/id_ed25519
	unset DECRYPT_PASS

	rm -rf ~/.bashrc ~/.bash_profile
	stow --no-folding -vt $HOME files

	find ~/.gnupg -type f -exec chmod 600 {} \;
	find ~/.gnupg -type d -exec chmod 700 {} \;

	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/id_ed25519
	chmod 644 ~/.ssh/id_ed25519.pub

	key="3205E18CEDD2C007"
	if ! gpg --list-keys $key &> /dev/null; then
		gpg --recv-keys $key
		echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key $key trust
	fi
}

case $OS in
	Linux)
		[ -f /etc/redhat-release ] || error "Unsupported Linux"
		if ! command -v sudo &>/dev/null; then
			if [ $EUID -ne 0 ]; then
				echo "Unable to install packages without sudo"
				exit 1
			fi

			dnf install -y sudo git
		else
			sudo dnf install -y git
		fi

		ensure_remote
		. ./scripts/linux.sh
		;;
	Darwin)
		ensure_remote
		. ./scripts/mac.sh
		;;
	*)
		error "Unsupported OS: $OS"
		;;
esac

echo "=============================================="
echo "Done with setup, probably best to relog/reboot"
