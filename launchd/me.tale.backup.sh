#!/usr/bin/env zsh

export RESTIC_PASSWORD=$(security find-generic-password -s restic-pass -w)
export B2_ACCOUNT_ID=$(security find-generic-password -s b2-id -w)
export B2_ACCOUNT_KEY=$(security find-generic-password -s b2-key -w)

RESTIC_EXCLUDE="$DOTDIR/config/restic/excludes.txt"
DEVELOPER_PATH="$HOME/Developer"

if [[ ! -d $DEVELOPER_PATH ]]; then
	echo $(date +"%Y-%m-%d %T") "Developer path not found."
	exit 1
fi

if [[ ! -f $RESTIC_EXCLUDE ]]; then
	echo $(date +"%Y-%m-%d %T") "Restic exclude file not found."
	exit 1
fi

if [[ ! -f /opt/homebrew/bin/restic ]]; then
	echo $(date +"%Y-%m-%d %T") "Restic not found."
	exit 1
fi

if [[ -z $OVERRIDE_BATTERY ]]; then
	if [[ $(pmset -g ps | head -1) =~ "Battery" ]]; then
		echo $(date +"%Y-%m-%d %T") "Computer is not connected to the power source."
		exit 1
	fi
fi

if [[ -z $RESTIC_PASSWORD ]]; then
	echo $(date +"%Y-%m-%d %T") "Restic password not found."
	exit 1
fi

echo $(date +"%Y-%m-%d %T") "Starting backup to SFTP"
command restic -r sftp:ftp.tale.me:/tale/restic backup $DEVELOPER_PATH \
	--exclude-file $RESTIC_EXCLUDE \
	--verbose

echo $(date +"%Y-%m-%d %T") "Starting backup to B2"
command restic -r b2:tale-ftp:/tale/restic backup $DEVELOPER_PATH \
	--exclude-file $RESTIC_EXCLUDE \
	--verbose

