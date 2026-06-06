emulate -L zsh
local ROOT_DIR="$HOME/code/gh"
[ -d "$ROOT_DIR" ] || return 0

local selected=$(
	find "$ROOT_DIR" -maxdepth 3 -name .git -prune 2>/dev/null \
	| sed 's:/\.git$::' | sort -u \
	| while IFS= read -r path; do
		printf '%s\t%s\n' "${path#"$ROOT_DIR"/}" "$path"
	done \
	| fzf --delimiter='\t' --with-nth=1 --prompt='project ❯ ' | cut -f2
) || return 0
[ -n "$selected" ] || return 0

local RAISE='on run argv
	set p to item 1 of argv
	tell application "Ghostty"
		repeat with w in windows
			repeat with t in terminals of w
			set cwd to (working directory of t)
			if cwd is p or cwd starts with (p & "/") then
				focus t
				activate
				return "raised"
			end if
			end repeat
		end repeat
	end tell
	return "none"
end run'

if [ "$(osascript -e "$RAISE" "$selected")" = "raised" ]; then
	return 0
fi

local CREATE='on run argv
set p to item 1 of argv
	tell application "Ghostty"
		set cfg to new surface configuration
		set initial working directory of cfg to p
		new window with configuration cfg
		activate
	end tell
end run'

osascript -e "$CREATE" "$selected"
