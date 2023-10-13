#!/usr/bin/env bash

regex="^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test){1}(\([\w\-\.]+\))?(!)?: (.*)$"

if [[ "$(cat "$1")" =~ $regex ]]; then
	exit 0
else
	echo "\033[0;31m[x]\033[0m Failed 'conventional-commits' validation" >&2
	echo "\033[0;31m[x]\033[0m https://www.conventionalcommits.org/en/v1.0.0/" >&2
	exit 1
fi
