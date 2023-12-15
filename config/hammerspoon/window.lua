require("hs.hotkey")
require("hs.window")

-- Constructs a function for window resizing
local function window(side)
	local function resizeWindow()
		local win = hs.window.focusedWindow()
		local max = win:screen():frame()
		local frame = win:frame()

		if side == "left" then
			frame.x = 0;
			frame.y = 0;
			frame.w = max.w / 2;
			frame.h = max.h;
		elseif side == "right" then
			frame.x = max.w / 2;
			frame.y = 0;
			frame.w = max.w / 2;
			frame.h = max.h;
		elseif side == "center" then
			frame.x = (max.w - frame.w) / 2;
			frame.y = (max.h - frame.h) / 2;
		elseif side == "max" then
			frame.x = 0;
			frame.y = 0;
			frame.w = max.w;
			frame.h = max.h;
		end

		win:setFrame(frame)
	end

	return resizeWindow
end

hs.window.animationDuration = 0.03
hs.hotkey.bind({ "ctrl", "shift" }, "H", window("left"))
hs.hotkey.bind({ "ctrl", "shift" }, "K", window("max"))
hs.hotkey.bind({ "ctrl", "shift" }, "L", window("right"))
hs.hotkey.bind({ "ctrl", "shift" }, "J", window("center"))
