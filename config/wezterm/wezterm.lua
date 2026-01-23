local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Font.
config.font = wezterm.font({
	family = "Fira Code",
	weight = "Regular",
	-- Disable ligatures.
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 10.0
config.line_height = 1.2

-- Color scheme: there are a whole bunch of these available which you can
-- browse in the docs. This was just the first one that seemed decent.
config.color_scheme = "Afterglow"

-- Use the TUI tab bar instead of the native one.
config.use_fancy_tab_bar = false

-- Disable padding in the pane. It's literally free screen real estate.
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Only set RESIZE for window decorations, no TITLE, buying some more screen
-- real estate. NONE does not work with aerospace.
config.window_decorations = "RESIZE"

-- Do not need to update the status bar so often.
config.status_update_interval = 10000 -- milliseconds

local function get_weather()
	-- TODO: How do I a nix executable this into the system path? Absolute path
	-- seems a bit fragile.
	local _, weather, _ = wezterm.run_child_process({ "/run/current-system/sw/bin/wttr" })
	return weather
end

-- Right status bar info.
wezterm.on("update-status", function(window, pane)
	local domain_name = pane:get_domain_name()
	local date <const> = wezterm.strftime("%Y-%m-%d %H:%M")
	local _, weather = pcall(get_weather)
	local status = domain_name .. " | " .. weather .. " | " .. date

	window:set_right_status(wezterm.format({ { Text = status } }))
end)

return config
