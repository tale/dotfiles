require("window")
require("hs.ipc")
require("hs.hotkey")
require("hs.application")
require("hs.pathwatcher")

-- Option + Space: Toggle WezTerm
hs.hotkey.bind({ "alt" }, "space", function()
	local app = hs.application.get("WezTerm")
	if app then
		if app:isFrontmost() then
			app:hide()
			return
		end
	end

	hs.application.launchOrFocus("WezTerm")
end)

-- Maximize WezTerm on launch
hs.application.watcher.new(function(name, event, app)
	if name == "WezTerm" then
		if event == hs.application.watcher.launched then
			app:mainWindow():maximize()
		end
	end
end):start()

-- Hot Reloading Configuration
hs.pathwatcher.new(
	os.getenv("HOME") .. "/.config/dotfiles/config/hammerspoon/",
	hs.reload
):start()
