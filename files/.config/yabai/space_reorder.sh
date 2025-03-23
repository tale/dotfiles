#!/usr/bin/env bash
yabai -m space "main" --move 1 2>/dev/null || true
yabai -m space "chrome" --move 2 2>/dev/null || true
yabai -m space "discord" --move 3 2>/dev/null || true
yabai -m space "ghostty" --move 4 2>/dev/null || true
yabai -m space "extra" --move 5 2>/dev/null || true
yabai -m space "spotify" --move 6 2>/dev/null || true
yabai -m space "mail" --move 7 2>/dev/null || true

# We need to reapply our rules related to space labels.
# This ensures they move if the spaces move.
yabai -m rule --apply app="^Zed$" space=main
yabai -m rule --apply app="^Ghostty$" space=ghostty
yabai -m rule --apply app="^Chrome$" space=chrome
yabai -m rule --apply app="^Discord$" space=discord
yabai -m rule --apply app="^Spotify$" space=spotify
yabai -m rule --apply app="^Mail$" space=mail
