#!/usr/bin/env bash
SOURCE=${1:-"unknown"}
echo "$SOURCE triggered display rebalancing"

# Ensures we always have our 7 spaces and they are labeled correctly.
# Sometimes, multiple displays can create or remove spaces, requiring this.
SPACES_QUERY=$(yabai -m query --spaces)
SPACES_COUNT=$(echo $SPACES_QUERY | jq length)

# Find the difference between SPACES_COUNT and 7
# If the difference is positive, we need to remove spaces.
# If the difference is negative, we need to add spaces.
difference=$((SPACES_COUNT - 7))
if [ $difference -gt 0 ]; then
	# Remove the last space until we have 7 spaces.
	for i in $(seq 1 $difference); do
		SPACE_ID=$(echo $SPACES_QUERY | jq -r ".[$SPACES_COUNT - $i].index")
		yabai -m space $SPACE_ID --destroy
	done
elif [ $difference -lt 0 ]; then
	# Add spaces until we have 7 spaces.
	for i in $(seq 1 $((difference * -1))); do
		yabai -m space --create
	done
fi

# Label the spaces correctly.
yabai -m space 1 --label "main"
yabai -m space 2 --label "chrome"
yabai -m space 3 --label "discord"
yabai -m space 4 --label "ghostty"
yabai -m space 5 --label "extra"
yabai -m space 6 --label "spotify"
yabai -m space 7 --label "mail"

# Now we need to balance our displays.
# This is "custom" in that I only have at most 2 external displays.
DISPLAY_QUERY=$(yabai -m query --displays)
DISPLAY_COUNT=$(echo $DISPLAY_QUERY | jq length)

# Display Configuration:
# 1: All spaces on the main display.
# 2: First 4 spaces on the main display, remaining on the second display.
# 3: First 3 spaces on the main display, 4 and 5 on the second, rest on the third.
case $DISPLAY_COUNT in
	1)
		# All spaces on the main display.
		# We don't need to do anything here.
		;;
	2)
		# First 4 spaces on the main display, remaining on the second display.
		echo "Balancing spaces for 2 displays."

		for i in $(seq 1 4); do
			yabai -m space $i --display 1 2> /dev/null || true
		done
		for i in $(seq 5 7); do
			yabai -m space $i --display 2 2> /dev/null || true
		done
		;;
	3)
		# First 3 spaces on the main display, 4 and 5 on the second, rest on the third.
		echo "Balancing spaces for 3 displays."

		for i in $(seq 1 3); do
			yabai -m space $i --display 1 2> /dev/null || true
		done
		for i in $(seq 4 5); do
			yabai -m space $i --display 2 2> /dev/null || true
		done
		for i in $(seq 6 7); do
			yabai -m space $i --display 3 2> /dev/null || true
		done
		;;
	*)
		echo "Unknown display configuration, not changing anything."
		;;
esac

# We need to reapply our rules related to space labels.
# This ensures they move if the spaces move.
yabai -m rule --apply app="^Zed$" space=main
yabai -m rule --apply app="^Ghostty$" space=ghostty
yabai -m rule --apply app="^Chrome$" space=chrome
yabai -m rule --apply app="^Discord$" space=discord
yabai -m rule --apply app="^Spotify$" space=spotify
yabai -m rule --apply app="^Mail$" space=mail
