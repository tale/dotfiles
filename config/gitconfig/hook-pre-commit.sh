#!/usr/bin/env bash

exec 1>&2
exec < /dev/tty
export GPG_TTY=$(tty)

NAME=$(git config user.name)
EMAIL=$(git config user.email)
KEY=$(git config user.signingkey)

# If gpg.program is unset in .gitconfig, default to `gpg`
PROGRAM=$(git config --global gpg.program || echo "gpg")

command echo "$($PROGRAM --list-keys $KEY)" | grep "<$EMAIL>" > /dev/null 2>&1
STATUS=$?

if [[ ! $STATUS == "0" ]]; then
	echo "\033[0;31m[x]\033[0m Mismatch between git email and GPG email"
	exit 1
fi
