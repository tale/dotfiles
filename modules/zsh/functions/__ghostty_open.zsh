local dir="${1:?Usage: __ghostty_open <dir>}"

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

if [ "$(osascript -e "$RAISE" "$dir")" = "raised" ]; then
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

osascript -e "$CREATE" "$dir"
