#!/usr/bin/env zsh

export RESTIC_PASSWORD=$(security find-generic-password -s restic-pass -w)
RESTIC_EXCLUDE="$DOTDIR/config/restic/excludes.txt"
DEVELOPER_PATH="$HOME/Developer"

echo $(date +"%Y-%m-%d %T") "Starting backup."

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

if [[ $(pmset -g ps | head -1) =~ "Battery" ]]; then
	echo $(date +"%Y-%m-%d %T") "Computer is not connected to the power source."
	exit 1
fi

if [[ -z $RESTIC_PASSWORD ]]; then
	echo $(date +"%Y-%m-%d %T") "Restic password not found."
	exit 1
fi

command restic -r sftp:ftp.tale.me:/tale/restic backup $DEVELOPER_PATH \
	--exclude-file $RESTIC_EXCLUDE \
	--verbose

echo $(date +"%Y-%m-%d %T") "Backup finished."

