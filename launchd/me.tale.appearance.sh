#!/bin/bash

if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == "Dark" ]]; then
	git config --global delta.light false
else
	git config --global delta.light false
fi

printf '[%s] (%s) %s\n' "me.tale.appearance" "$(date '+%H:%M:%S')" "Updated non-dynamic interfaces"
