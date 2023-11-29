local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Maximize windows on startup
wezterm.on('gui-startup', function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.enable_tab_bar = false
config.check_for_updates = false
config.color_scheme = 'GitHub Dark'

-- Disable ligatures because they're annoying
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.font = wezterm.font('IosevkaTerm Nerd Font Mono', {
	weight = 'Regular'
})

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0, -- Tmux already has stupid padding
}

config.font_size = 15.0
config.animation_fps = 120
config.audible_bell = 'SystemBeep'
config.window_close_confirmation = 'NeverPrompt'
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'
config.window_decorations = 'RESIZE'

if wezterm.gui then
	local gpus = wezterm.gui.enumerate_gpus()
	config.webgpu_preferred_adapter = gpus[1]
	config.front_end = 'WebGpu'
end

config.keys = {
	{
		key = 'L',
		mods = 'CTRL',
		action = wezterm.action.ShowDebugOverlay
	},
	{
		key = 'Enter',
		mods = 'META',
		action = wezterm.action.DisableDefaultAssignment
	},
	{
		key = 'Space',
		mods = 'CTRL | SHIFT',
		action = wezterm.action.DisableDefaultAssignment
	}
}

return config
